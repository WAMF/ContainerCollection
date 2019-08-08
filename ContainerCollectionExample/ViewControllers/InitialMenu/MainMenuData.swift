//  Copyright © 2019 We Are Mobile First.

import UIKit

struct MainMenuData {
    struct SectionData {
        struct RowData {
            enum CellIdentifier: String {
                case basicCell, descriptionCell
            }

            enum Action {
                case performSegue(String), instantiateViewController(UIViewController.Type)
            }

            let cellIdentifier: CellIdentifier
            let cellTitle: String
            let action: Action?
        }

        let sectionTitle: String
        let rowData: [RowData]
    }

    let sectionData: [SectionData]
}

extension MainMenuData {
    static func make() -> MainMenuData {
        return MainMenuData(sectionData: [standaloneNativeComponentsSection, stackedNativeComponentsSection])
    }

    private static var standaloneNativeComponentsSection: SectionData {
        let description = "This section presents several view controllers made of native components (coming from UIKit, SceneKit, MapKit or AVKit) which do work as standalone view controllers. This is to prove that in order to make a view controller work with CollectionContainer, the first step is the view controller to work by itself. Data is generated randomly from a given set, so every time the view controller should be different."
        let descriptionRow = SectionData.RowData(cellIdentifier: .descriptionCell, cellTitle: description, action: nil)
        let horizontalRailRow = SectionData.RowData(cellIdentifier: .basicCell,
                                                    cellTitle: "Horizontal rail",
                                                    action: .instantiateViewController(HorizontalRailViewController.self))
        let imageGalleryRow = SectionData.RowData(cellIdentifier: .basicCell,
                                                  cellTitle: "Image gallery",
                                                  action: .instantiateViewController(ImageGalleryViewController.self))
        let imageRow = SectionData.RowData(cellIdentifier: .basicCell,
                                           cellTitle: "Image with title",
                                           action: .performSegue("showImage"))
        let mapRow = SectionData.RowData(cellIdentifier: .basicCell,
                                         cellTitle: "Map",
                                         action: .performSegue("showMapKit"))
        let sceneRow = SectionData.RowData(cellIdentifier: .basicCell,
                                           cellTitle: "Scene: spinning geometric form",
                                           action: .performSegue("showSceneKit"))
        let videoPlayerRow = SectionData.RowData(cellIdentifier: .basicCell,
                                                 cellTitle: "Video player",
                                                 action: .performSegue("showVideoPlayer"))

        return SectionData(sectionTitle: "Standalone native components", rowData: [
            descriptionRow,
            horizontalRailRow,
            imageGalleryRow,
            imageRow,
            mapRow,
            sceneRow,
            videoPlayerRow
        ])
    }

    private static var stackedNativeComponentsSection: SectionData {
        let description = "This section shows how the CollectionContainer is able to stack several view controllers in a single page. As before, data is generated randomly from a given set and the view controllers are selected randomly, so every time the page rendered should be different."
        let descriptionRow = SectionData.RowData(cellIdentifier: .descriptionCell, cellTitle: description, action: nil)
        let containerTableViewRow = SectionData.RowData(cellIdentifier: .basicCell,
                                                        cellTitle: "Container table view",
                                                        action: .performSegue("showContainerCollection"))
        return SectionData(sectionTitle: "Stacked native components", rowData: [descriptionRow, containerTableViewRow])
    }
}
