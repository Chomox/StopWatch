//
//  StopWatchModel.swift
//  StopWatch
//
//  Created by Motoyuki Ito on 2019/10/16.
//  Copyright © 2019 Motoyuki Ito. All rights reserved.
//

import UIKit

final class StopWatchModel: NSObject {
	
}

extension StopWatchModel: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		return cell
	}
}
