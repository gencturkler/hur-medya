import AppKit
import SwiftUI

// One shared visual language, with native light/dark appearance and motion preferences.
enum HPMedyaPalette {
    static func adaptive(_ light:(Double,Double,Double),_ dark:(Double,Double,Double))->NSColor {
        NSColor(name:nil) { appearance in
            let rgb=appearance.bestMatch(from:[.darkAqua,.aqua]) == .darkAqua ? dark:light
            return NSColor(srgbRed:rgb.0,green:rgb.1,blue:rgb.2,alpha:1)
        }
    }
    static let canvas=Color(nsColor:adaptive((0.969,0.949,0.980),(0.208,0.051,0.298)))
    static let surface=Color(nsColor:adaptive((1,1,1),(0.271,0.102,0.369)))
    static let inset=Color(nsColor:adaptive((0.937,0.902,0.957),(0.169,0.039,0.243)))
    static let forest=Color(nsColor:adaptive((0.208,0.051,0.298),(0.86,0.78,0.91)))
    static let sand=Color(nsColor:adaptive((1,0.945,0.780),(0.300,0.220,0.030)))
    static let sage=Color(nsColor:adaptive((0.918,0.867,0.949),(0.290,0.114,0.388)))
    static let border=Color.primary.opacity(0.075)
    static let gold=HPMedyaArtwork.gold
    static let ink=HPMedyaArtwork.ink
    static let goldInk=Color(nsColor:adaptive((0.573,0.373,0.012),(0.992,0.745,0.059)))
    static let buttonInk=Color(red:0.208,green:0.051,blue:0.298)
    static let goldEnd=Color(red:0.996,green:0.831,blue:0.361)
}
extension Color { static let hpmedya=Color(nsColor:HPMedyaPalette.gold) }

enum HPMedyaMotion {
    static var enabled:Bool { !UserDefaults.standard.bool(forKey:"reduceAnimations") && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion }
}
enum HPMedyaAppearance {
    @MainActor static func apply(_ choice:String?=nil) {
        let choice=choice ?? UserDefaults.standard.string(forKey:"appAppearance") ?? "system"
        NSApp.appearance=choice=="light" ? NSAppearance(named:.aqua):choice=="dark" ? NSAppearance(named:.darkAqua):nil
    }
}

struct HPMedyaMotionModifier<Value:Equatable>:ViewModifier {
    let value:Value
    @Environment(\.accessibilityReduceMotion) private var systemReduced
    @AppStorage("reduceAnimations") private var reduced=false
    func body(content:Content)->some View { content.animation(systemReduced || reduced ? nil:.spring(response:0.32,dampingFraction:0.88),value:value) }
}
struct HPMedyaEntrance:ViewModifier {
    var delay=0.0
    @State private var visible=false
    @Environment(\.accessibilityReduceMotion) private var systemReduced
    @AppStorage("reduceAnimations") private var reduced=false
    func body(content:Content)->some View {
        content.opacity(visible ? 1:0).offset(y:visible || systemReduced || reduced ? 0:8)
            .onAppear {
                if systemReduced || reduced { visible=true }
                else { withAnimation(.easeOut(duration:0.24).delay(delay)) { visible=true } }
            }
    }
}
extension View {
    func hpmedyaAnimation<V:Equatable>(value:V)->some View { modifier(HPMedyaMotionModifier(value:value)) }
    func hpmedyaEntrance(delay:Double=0)->some View { modifier(HPMedyaEntrance(delay:delay)) }
    func hpmedyaCard(radius:CGFloat=22)->some View {
        background(HPMedyaPalette.surface,in:RoundedRectangle(cornerRadius:radius,style:.continuous))
            .overlay(RoundedRectangle(cornerRadius:radius,style:.continuous).strokeBorder(HPMedyaPalette.border,lineWidth:1))
    }
}

enum HPMedyaButtonKind { case primary,secondary,quiet }
struct HPMedyaButtonStyle:ButtonStyle {
    var kind:HPMedyaButtonKind = .secondary
    var compact=false
    init(_ kind:HPMedyaButtonKind = .secondary,compact:Bool=false) { self.kind=kind;self.compact=compact }
    func makeBody(configuration:Configuration)->some View { HPMedyaButtonBody(configuration:configuration,kind:kind,compact:compact) }
}
private struct HPMedyaButtonBody:View {
    let configuration:ButtonStyleConfiguration
    let kind:HPMedyaButtonKind
    let compact:Bool
    @State private var hovered=false
    @Environment(\.isEnabled) private var enabled
    @Environment(\.isFocused) private var focused
    @Environment(\.accessibilityReduceMotion) private var systemReduced
    @AppStorage("reduceAnimations") private var reduced=false
    private var primary:Bool { kind == .primary }
    var body:some View {
        configuration.label.font(.system(size:compact ? 11:13,weight:.semibold,design:.rounded))
            .multilineTextAlignment(.center)
            .fixedSize(horizontal:false,vertical:true)
            .frame(minHeight:compact ? 14:18,alignment:.center)
            .padding(.horizontal,compact ? 10:15).padding(.vertical,compact ? 7:11)
            .foregroundStyle(primary ? HPMedyaPalette.buttonInk:Color.primary)
            .background {
                RoundedRectangle(cornerRadius:compact ? 10:13,style:.continuous)
                    .fill(primary ? AnyShapeStyle(LinearGradient(colors:[Color.hpmedya,HPMedyaPalette.goldEnd],startPoint:.leading,endPoint:.trailing)):AnyShapeStyle(kind == .quiet ? Color.clear:HPMedyaPalette.surface))
                    .overlay(RoundedRectangle(cornerRadius:compact ? 10:13,style:.continuous).strokeBorder(primary ? Color.white.opacity(0.12):HPMedyaPalette.border,lineWidth:kind == .quiet ? 0:1))
            }
            .overlay(RoundedRectangle(cornerRadius:compact ? 10:13).fill(Color.primary.opacity(hovered && !primary ? 0.035:0)))
            .overlay(RoundedRectangle(cornerRadius:compact ? 10:13).strokeBorder(focused ? HPMedyaPalette.goldInk:Color.clear,lineWidth:2).padding(-3))
            .shadow(color:primary && enabled ? Color.hpmedya.opacity(hovered ? 0.20:0.10):.clear,radius:hovered ? 9:5,y:3)
            .scaleEffect(systemReduced || reduced ? 1:configuration.isPressed ? 0.97:hovered && enabled ? 1.015:1)
            .opacity(enabled ? 1:0.4).contentShape(RoundedRectangle(cornerRadius:13))
            .onHover { hovered=$0 }
            .animation(systemReduced || reduced ? nil:.easeOut(duration:0.14),value:configuration.isPressed)
            .animation(systemReduced || reduced ? nil:.easeOut(duration:0.16),value:hovered)
    }
}
struct HPMedyaGroupBoxStyle:GroupBoxStyle {
    func makeBody(configuration:Configuration)->some View {
        VStack(alignment:.leading,spacing:16) {
            configuration.label.font(.system(size:13,weight:.semibold,design:.rounded)).foregroundStyle(HPMedyaPalette.forest)
            configuration.content
        }.padding(20).frame(maxWidth:.infinity,alignment:.leading).hpmedyaCard()
    }
}

struct HPMedyaMark:View {
    var size:CGFloat=44
    var happy=false
    var body:some View {
        Image(nsImage:HPMedyaArtwork.mark(size:size*2,happy:happy)).resizable().interpolation(.high).frame(width:size,height:size).accessibilityHidden(true)
    }
}

struct HPMedyaPill:View {
    let title:String
    var symbol:String?=nil
    var color:Color=HPMedyaPalette.forest
    var body:some View {
        HStack(spacing:5) { if let symbol { Image(systemName:symbol) };LText(title) }
            .font(.system(size:10,weight:.semibold,design:.rounded)).foregroundStyle(color == .hpmedya ? HPMedyaPalette.goldInk:color)
            .padding(.horizontal,9).padding(.vertical,5).background(color.opacity(0.09),in:Capsule())
    }
}
struct HPMedyaPageHeading:View {
    let eyebrow:String
    let title:String
    let subtitle:String
    var body:some View {
        VStack(alignment:.leading,spacing:8) {
            LText(eyebrow.uppercased()).font(.system(size:10,weight:.bold,design:.rounded)).tracking(1.4).foregroundStyle(HPMedyaPalette.goldInk)
            LText(title).font(.system(size:27,weight:.bold,design:.rounded)).tracking(-0.7)
            LText(subtitle).font(.system(size:12)).foregroundStyle(.secondary).fixedSize(horizontal:false,vertical:true)
        }
    }
}
struct HPMedyaCheck:View {
    @State private var arrived=false
    var body:some View {
        Image(systemName:"checkmark").font(.system(size:14,weight:.bold)).foregroundStyle(HPMedyaPalette.forest)
            .frame(width:34,height:34).background(HPMedyaPalette.sage,in:Circle())
            .scaleEffect(arrived ? 1:0.75).opacity(arrived ? 1:0)
            .hpmedyaAnimation(value:arrived).onAppear{arrived=true}.accessibilityHidden(true)
    }
}
