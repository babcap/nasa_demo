//
//  DownloadManager.swift
//  NasaDemo
//
//  Created by Arthur on 25.08.2023.
//

import Foundation

class DownloadManager: NSObject {
    fileprivate var operations = [Int: DownloadOperation]()

    private let queue: OperationQueue = {
        let _queue = OperationQueue()
        _queue.name = "download"
        _queue.maxConcurrentOperationCount = 4
        return _queue
    }()

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    @discardableResult
    func queueDownload(_ url: URL) -> DownloadOperation {
        let operation = DownloadOperation(session: session, url: url)
        operations[operation.task.taskIdentifier] = operation
        queue.addOperation(operation)
        return operation
    }

    func cancelAll() {
        queue.cancelAllOperations()
    }
}

// MARK: URLSessionDownloadDelegate methods

extension DownloadManager: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        operations[downloadTask.taskIdentifier]?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        operations[downloadTask.taskIdentifier]?.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
}

// MARK: URLSessionTaskDelegate methods

extension DownloadManager: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)  {
        let key = task.taskIdentifier
        operations[key]?.urlSession(session, task: task, didCompleteWithError: error)
        operations.removeValue(forKey: key)
    }
}

class DownloadOperation : AsynchronousOperation {
    let task: URLSessionTask
    
    init(session: URLSession, url: URL) {
        task = session.downloadTask(with: url)
        super.init()
    }
    
    override func cancel() {
        task.cancel()
        super.cancel()
    }
    
    override func main() {
        task.resume()
    }
}

// MARK: NSURLSessionDownloadDelegate methods

extension DownloadOperation: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard
            let httpResponse = downloadTask.response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode
        else {
            // handle invalid return codes however you'd like
            return
        }

        do {
            let manager = FileManager.default
            let destinationURL = try manager
                .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(downloadTask.originalRequest!.url!.lastPathComponent)
            try? manager.removeItem(at: destinationURL)
            try manager.moveItem(at: location, to: destinationURL)
        } catch {
            print(error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("\(downloadTask.originalRequest!.url!.absoluteString) \(progress)")
    }
}

// MARK: URLSessionTaskDelegate methods

extension DownloadOperation: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)  {
        defer { finish() }
        
        if let error = error {
            print(error)
            return
        }
    }
    
}
