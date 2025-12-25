import UIKit

final class CloudinaryUploadService {

    static let shared = CloudinaryUploadService()

    private let cloudName = "dvlpfkqeu"
    private let uploadPreset = "fixify"

    private init() {}

    func upload(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            completion(nil); return
        }

        let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"

        let boundary = UUID().uuidString
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        func add(_ s: String) { body.append(s.data(using: .utf8)!) }

        add("--\(boundary)\r\n")
        add("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n")
        add("\(uploadPreset)\r\n")

        add("--\(boundary)\r\n")
        add("Content-Disposition: form-data; name=\"file\"; filename=\"img.jpg\"\r\n")
        add("Content-Type: image/jpeg\r\n\r\n")
        body.append(data)
        add("\r\n--\(boundary)--\r\n")

        req.httpBody = body

        URLSession.shared.dataTask(with: req) { data, _, _ in
            guard
                let data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let url = json["secure_url"] as? String
            else { completion(nil); return }

            completion(url)
        }.resume()
    }
}

