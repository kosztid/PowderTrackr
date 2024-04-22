//
//  PowderTrackrWidgetBundle.swift
//  PowderTrackrWidget
//
//  Created by Dominik Kosztolánczi on 22/04/2024.
//

import WidgetKit
import SwiftUI

@main
struct PowderTrackrWidgetBundle: WidgetBundle {
    var body: some Widget {
        PowderTrackrWidget()
        PowderTrackrWidgetLiveActivity()
    }
}
