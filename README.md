#  Async Await

### 1. Sync
- `Data(contentsOf: URL)`

### 2. URLSession DataTask
- `func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask`

### 3. URLSession Async
- `func data(from url: URL, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse)`
