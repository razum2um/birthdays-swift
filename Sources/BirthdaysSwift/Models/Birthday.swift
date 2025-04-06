import Fluent
import Vapor

final class Birthday: Model, Content, @unchecked Sendable {
    static let schema = "birthdays"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @Field(key: "birthday")
    var birthday: Date

    init() {}

    init(id: String? = nil, birthday: Date) {
        self.id = id
        self.birthday = birthday
    }
}
