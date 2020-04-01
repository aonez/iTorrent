//
//  Torrent.swift
//  iTorrent
//
//  Created by Daniil Vinogradov on 30.03.2020.
//  Copyright © 2020  XITRIX. All rights reserved.
//

import Foundation

class TorrentSdk {
    public static func initEngine(downloadFolder: String, configFolder: String) {
        let appName = "\(Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String) \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
        init_engine(appName, downloadFolder, configFolder)
    }
    
    public static func getTorrents() -> [TorrentModel] {
        let res = get_torrent_info()
        let torrents = Array(UnsafeBufferPointer(start: res.torrents, count: Int(res.count)))
        return torrents.map { TorrentModel($0) }
    }
    
    public static func addTorrent(torrentPath: String) -> String? {
        return String(validatingUTF8: add_torrent(torrentPath))
    }
    
    public static func addTorrent(torrentPath: String, states: [Int]) {
        let st = states.map({Int32($0)})
        add_torrent_with_states(torrentPath, UnsafeMutablePointer(mutating: st))
    }
    
    public static func addMagnet(magnetUrl: String) -> String? {
        String(validatingUTF8: add_magnet(magnetUrl))
    }
    
    public static func removeTorrent(hash: String, withFiles: Bool) {
        remove_torrent(hash, withFiles ? 1 : 0)
    }
    
    public static func saveMagnetToFile(hash: String) {
        save_magnet_to_file(hash)
    }
    
    public static func getTorrentFileHash(torrentPath: String) -> String? {
        String(validatingUTF8: get_torrent_file_hash(torrentPath))
    }
    
    public static func getMagnetHash(magnetUrl: String) -> String? {
        String(validatingUTF8: get_magnet_hash(magnetUrl))
    }
    
    public static func getTorrentMagnetLink(hash: String) -> String? {
        String(validatingUTF8: get_torrent_magnet_link(hash))
    }
    
    public static func getFilesOfTorrentByPath(path: String) -> (title: String, files: [FileModel])? {
        let res = get_files_of_torrent_by_path(path)
        if res.error == 1 {
            return nil
        }
        
        let title = String(validatingUTF8: res.title) ?? "ERROR"
        return (title, Array(UnsafeBufferPointer(start: res.files, count: Int(res.size))).map { FileModel(file: $0, isPreview: true) })
    }
    
    public static func getFilesOfTorrentByHash(hash: String) -> [FileModel]? {
        let res = get_files_of_torrent_by_hash(hash)
        if res.error == 1 {
            return nil
        }
        
        return Array(UnsafeBufferPointer(start: res.files, count: Int(res.size))).map { FileModel(file: $0) }
    }
    
    public static func setTorrentFilesPriority(hash: String, states: [Int]) {
        let st = states.map({Int32($0)})
        set_torrent_files_priority(hash, UnsafeMutablePointer(mutating: st))
    }
    
    public static func setTorrentFilePriority(hash: String, fileNum: Int, state: Int) {
        set_torrent_file_priority(hash, Int32(fileNum), Int32(state))
    }
    
    public static func resumeToApp() {
        resume_to_app()
    }
    
    public static func saveFastResume() {
        save_fast_resume()
    }
    
    public static func stopTorrent(hash: String) {
        stop_torrent(hash)
    }
    
    public static func startTorrent(hash: String) {
        start_torrent(hash)
    }
    
    public static func rehashTorrent(hash: String) {
        rehash_torrent(hash)
    }
    
    public static func scrapeTracker(hash: String) {
        scrape_tracker(hash)
    }
    
    public static func getTrackersByHash(hash: String) -> [TrackerModel] {
        let res = get_trackers_by_hash(hash)
        
        var trackers: [TrackerModel] = []
        for iter in 0..<Int(res.size) {
            let tracker = TrackerModel(tracker_url: String(validatingUTF8: res.tracker_url[iter]) ?? "ERROR",
                                       seeders: res.seeders[iter],
                                       peers: res.peers[iter],
                                       leechs: res.leechs[iter],
                                       working: res.working[iter] == 1,
                                       verified: res.verified[iter] == 1)
            trackers.append(tracker)
        }
        
        return trackers
    }
    
    public static func addTrackerToTorrent(hash: String, trackerUrl: String) -> Int {
        Int(add_tracker_to_torrent(hash, trackerUrl))
    }
    
    public static func removeTrackersFromTorrent(hash: String, trackerUrls: [String]) -> Int {
        Utils.withArrayOfCStrings(trackerUrls) { args in
            Int(remove_tracker_from_torrent(hash, args, Int32(trackerUrls.count)))
        }
    }
    
    public static func setDownloadLimit(limitBytes: Int) {
        set_download_limit(Int32(limitBytes))
    }
    
    public static func setUploadLimits(limitBytes: Int) {
        set_upload_limit(Int32(limitBytes))
    }
    
    public static func setTorrentFilesSequential(hash: String, sequential: Bool) {
        set_torrent_files_sequental(hash, sequential ? 1 : 0)
    }
    
    public static func getTorrentFilesSequential(hash: String) -> Bool {
        get_torrent_files_sequental(hash) == 1
    }
    
    public static func setStoragePreallocation(allocate: Bool) {
        set_storage_preallocation(allocate ? 1 : 0)
    }
    
    public static func getStoragePreallocation() -> Bool {
        get_storage_preallocation() == 1
    }
}
