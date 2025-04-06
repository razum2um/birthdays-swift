import Fluent

struct CreateBirthday: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("birthdays")
            .field("id", .string, .identifier(auto: false))
            .field("birthday", .date, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("birthdays").delete()
    }
}
