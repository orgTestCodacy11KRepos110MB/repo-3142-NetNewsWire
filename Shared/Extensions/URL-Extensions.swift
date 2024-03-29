//
//  URL-Extensions.swift
//  NetNewsWire
//
//  Created by Stuart Breckenridge on 03/05/2020.
//  Copyright © 2020 Ranchero Software. All rights reserved.
//

import Foundation

extension URL {
	
	/// Extracts email address from a `URL` with a `mailto` scheme, otherwise `nil`.
	var emailAddress: String? {
		scheme == "mailto" ? URLComponents(url: self, resolvingAgainstBaseURL: false)?.path : nil
	}
	
	/// Percent encoded `mailto` URL for use with `canOpenUrl`. If the URL doesn't contain the `mailto` scheme, this is `nil`.
	var percentEncodedEmailAddress: URL? {
		scheme == "mailto" ? self.string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.url : nil
	}
	
	/// URL pointing to current app version release notes.
	static var releaseNotes: URL {
		var gitHub = "https://github.com/Ranchero-Software/NetNewsWire/releases/tag/"
		
		#if os(macOS)
		gitHub += "mac-"
		#else
		gitHub += "ios-"
		#endif

		gitHub += "\(Bundle.main.versionNumber)-\(Bundle.main.buildNumber)"

		return URL(string: gitHub)!
	}
	
	func valueFor(_ parameter: String) -> String? {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
			  let queryItems = components.queryItems,
			  let value = queryItems.first(where: { $0.name == parameter })?.value else {
			return nil
		}
		return value
		
	}
	
	static func reparingIfRequired(_ link: String?) -> URL? {
		// If required, we replace any space characters to handle malformed links that are otherwise percent
		// encoded but contain spaces. For performance reasons, only try this if initial URL init fails.
		guard let link = link, !link.isEmpty else { return nil }
		if let url = URL(string: link) {
			return url
		} else {
			return URL(string: link.replacingOccurrences(of: " ", with: "%20"))
		}
	}

}
