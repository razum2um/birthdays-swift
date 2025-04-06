import Fluent
import Vapor

struct BirthdayController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let birthdays = routes.grouped("hello")

        birthdays.group(":id") { birthday in
            birthday.get(use: self.index)
            birthday.put(use: self.save)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [String: String] {
        guard let id = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "ID parameter is required")
        }

        guard let birthday = try await Birthday.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Birthday not found for \(id)")
        }

        let calendar = Calendar.current
        let today = Date()
        let startOfToday = calendar.startOfDay(for: today)

        let birthdayComponents = calendar.dateComponents([.month, .day], from: birthday.birthday)
        let currentYear = calendar.component(.year, from: startOfToday)

        var thisYearBirthday = DateComponents()
        thisYearBirthday.year = currentYear
        thisYearBirthday.month = birthdayComponents.month
        thisYearBirthday.day = birthdayComponents.day

        guard let thisYearDate = calendar.date(from: thisYearBirthday) else {
            throw Abort(.internalServerError, reason: "Could not calculate birthday date")
        }

        let startOfBirthday = calendar.startOfDay(for: thisYearDate)

        let targetDate = startOfBirthday < startOfToday
            ? calendar.date(byAdding: .year, value: 1, to: startOfBirthday)!
            : startOfBirthday

        let daysUntil = calendar.dateComponents([.day], from: startOfToday, to: targetDate).day ?? 0

        let message: String
        if daysUntil == 0 {
            message = "Hello, \(id)! Happy birthday!"
        } else {
            message = "Hello, \(id)! Your birthday is in \(daysUntil) day(s)"
        }

        return ["message": message]
    }



    @Sendable
    func save(req: Request) async throws -> HTTPStatus {
        struct BirthdayRequest: Content {
            let dateOfBirth: String
        }

        guard let id = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "ID parameter is required")
        }

        let birthdayRequest = try req.content.decode(BirthdayRequest.self)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: birthdayRequest.dateOfBirth) else {
            throw Abort(.badRequest, reason: "Invalid date format. Use yyyy-MM-dd")
        }

        let existing = try await Birthday.find(id, on: req.db)

        if let existing = existing {
            existing.birthday = date
            try await existing.save(on: req.db)
        } else {
            let newBirthday = Birthday(id: id, birthday: date)
            try await newBirthday.save(on: req.db)
        }

        return .noContent
    }
}
