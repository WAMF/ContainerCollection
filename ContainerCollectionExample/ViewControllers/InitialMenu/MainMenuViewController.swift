//  Copyright © 2019 We Are Mobile First.

import UIKit

class MainMenuViewController: UIViewController {
    private enum Segue {
        static let containerTableView = "showContainerCollection"
    }

    private var menuData: MainMenuData? {
        didSet { tableView.reloadData() }
    }

    private let resourcesManager = ResourcesManager()

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        menuData = MainMenuData.make()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let mapViewController as MapViewController:
            mapViewController.mapViewData = resourcesManager.generateRandomMap()
        case let sceneViewController as SceneViewController:
            sceneViewController.sceneViewData = resourcesManager.generateRandomScene()
        case let videoPlayerViewController as VideoPlayerViewController:
            videoPlayerViewController.videoPlayerData = resourcesManager.generateRandomVideo()
        case let imageViewController as ImageViewController:
            imageViewController.imageData = resourcesManager.generateRandomImage()
        case let tableContainerViewController as TableContainerViewController:
            var numberOfElements = 20
            if let number = sender as? Int, number > 0, number < 10001 {
                numberOfElements = number
            }
            tableContainerViewController.elements = resourcesManager.generateRandomElements(number: numberOfElements)
        default:
            return
        }
    }
}

extension MainMenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuData?.sectionData.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionData = menuData?.sectionData[section] else { fatalError() }
        return sectionData.sectionTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData?.sectionData[section].rowData.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowData = menuData?.sectionData[indexPath.section].rowData[indexPath.row] else { fatalError() }
        let cell = tableView.dequeueReusableCell(withIdentifier: rowData.cellIdentifier.rawValue, for: indexPath)
        cell.textLabel?.text = rowData.cellTitle
        return cell
    }
}

extension MainMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return menuData?.sectionData[indexPath.section].rowData[indexPath.row].action != nil ? indexPath : nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let action = menuData?.sectionData[indexPath.section].rowData[indexPath.row].action else { return }
        switch action {
        case .performSegue(let identifier):
            if identifier == Segue.containerTableView, !resourcesManager.isRunningUITests {
                let alertController = UIAlertController(title: "Number of components?",
                                                        message: "How many components do you wish to stack? \n Minimum: 1, Maximum: 10000, Default: 20",
                                                        preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.keyboardType = .numberPad
                }
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    alertController.dismiss(animated: true, completion: nil)
                }
                let confirmAction: UIAlertAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
                    let number = Int(alertController.textFields?.first?.text ?? "20")
                    self?.performSegue(withIdentifier: Segue.containerTableView, sender: number)
                }
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                present(alertController, animated: true, completion: nil)
            } else {
                performSegue(withIdentifier: identifier, sender: nil)
            }
        case .instantiateViewController(let ViewControllerSubclass):
            pushViewController(ViewControllerSubclass.init())
        }
    }
}

private extension MainMenuViewController {
    func pushViewController(_ viewController: UIViewController) {
        switch viewController {
        case let horizontalRailViewController as HorizontalRailViewController:
            horizontalRailViewController.horizontalRailData = resourcesManager.generateRandomElement(for: .horizontalRail).data as? HorizontalRailData
        case let imageGalleryViewController as ImageGalleryViewController:
            imageGalleryViewController.imageGalleryData = resourcesManager.generateRandomElement(for: .imageGallery).data as? ImageGalleryData
        default:
            break
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
