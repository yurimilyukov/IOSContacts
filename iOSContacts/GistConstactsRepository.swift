import Foundation
import Dispatch

struct Contact {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
}

enum GetContactsError : Error{
    case requestFailed
    case decodingFailed
}

protocol ContactsRepository {
    func getContacts() throws -> [Contact]?
}

class GistConstactsRepository: ContactsRepository {
    private let path: String
    init(path: String) {
        self.path = path
    }
    func getContacts() throws -> [Contact]? {
        let sem = DispatchSemaphore(value: 0)
        let url = URL(string: path)
        let request = URLRequest(url: url!)
        var result: [Contact]?
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer {
                sem.signal()
            }
            do{// TODO: handle error
                guard let data = data, let response = response as? HTTPURLResponse,
                      (200..<300) ~= response.statusCode, error == nil else {
                    throw error ?? GetContactsError.requestFailed
                }
            
            struct GistContact : Codable {
                let firstname : String
                let lastname : String
                let phone : String
                let email : String
            }
                let contact = try JSONDecoder().decode([GistContact].self, from: data)
                result = contact.map{ Contact(firstName: $0.firstname, lastName: $0.lastname, email: $0.email, phone: $0.phone)
                }
                //result?.append(parsedContact)
            }
            catch{
                print("Request failed")
            }
            
        }
        task.resume()
        let time: DispatchTime = .now() + .seconds(5)
        sem.wait(timeout: time)
        return result
    }
}
