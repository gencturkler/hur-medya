import XCTest
@testable import HPMedyaUpdates

final class PublicUpdateChannelTests:XCTestCase {
    private let info:[String:Any]=["HPMedyaPublicUpdateRepository":"gencturkler/hur-medya","SUFeedURL":"https://github.com/gencturkler/hur-medya/releases/latest/download/appcast.xml"]
    private final class NoCredentials:UpdateCredentialStore,@unchecked Sendable {
        func token(for repository:GitHubRepository) throws->String { XCTFail("Anonymous migration read a private token");throw UpdateCredentialError.missing }
        func save(_ token:String,for repository:GitHubRepository) throws { XCTFail("Anonymous migration wrote a credential") }
        func remove(for repository:GitHubRepository) throws { XCTFail("Anonymous migration deleted a credential") }
    }
    func testOfficialChannelRequiresExactBundledFeed() {
        XCTAssertNotNil(PublicUpdateChannel(info:info))
        for address in ["http://github.com/gencturkler/hur-medya/releases/latest/download/appcast.xml","https://github.com/attacker/hpmedya-app/releases/latest/download/appcast.xml","https://github.com/gencturkler/hur-medya/releases/latest/download/appcast.xml?token=x"] {
            var altered=info;altered["SUFeedURL"]=address;XCTAssertNil(PublicUpdateChannel(info:altered))
        }
    }
    func testNewUsersAndLegacyUsersDoNotTouchCredentials() async {
        for previous in [nil,"gencturkler/tangerine","gencturkler/hpmedya","gencturkler/hur-medya"] as [String?] {
            let suite="HPMedyaPublicChannelTests.\(UUID())",defaults=UserDefaults(suiteName:suite)!
            defer { defaults.removePersistentDomain(forName:suite) }
            if let previous { defaults.set(previous,forKey:"TangerineUpdateGitHubRepository");defaults.set(true,forKey:"TangerineUpdateGitHubRequiresToken");defaults.set(true,forKey:"TangerineUpdateGitHubSavedToken") }
            defaults.set("retained",forKey:"history");defaults.set(false,forKey:"TangerineUpdateGitHubAutomaticChecks")
            await MainActor.run {
                let updater=AppUpdater(credentials:NoCredentials(),defaults:defaults,info:info)
                XCTAssertNil(updater.repository);XCTAssertFalse(updater.requiresToken);XCTAssertFalse(updater.hasSavedToken)
                XCTAssertEqual(updater.officialRepository?.slug,"gencturkler/hur-medya")
            }
            XCTAssertEqual(defaults.string(forKey:"history"),"retained")
            if previous != nil { XCTAssertEqual(defaults.object(forKey:"SUEnableAutomaticChecks") as? Bool,false) }
        }
    }
    func testUnrelatedCustomChannelIsPreserved() async {
        let suite="HPMedyaPublicChannelTests.\(UUID())",defaults=UserDefaults(suiteName:suite)!
        defer { defaults.removePersistentDomain(forName:suite) }
        defaults.set("example/custom",forKey:"TangerineUpdateGitHubRepository");defaults.set(true,forKey:"TangerineUpdateGitHubRequiresToken")
        await MainActor.run {
            let updater=AppUpdater(credentials:NoCredentials(),defaults:defaults,info:info)
            XCTAssertEqual(updater.repository?.slug,"example/custom");XCTAssertTrue(updater.requiresToken)
        }
    }
}
