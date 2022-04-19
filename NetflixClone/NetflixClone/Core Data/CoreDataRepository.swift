import Foundation
import CoreData
import UIKit

protocol CoreDataRepositoryType {
    func getAll() -> [MyList]
    func add(myListObject: MyList)
    func remove(myListObject: MyList)
    func objectInMyList(id: Int) -> Bool
}

class CoreDataRepository: CoreDataRepositoryType {
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext()
    func getAll() -> [MyList] {
        var myListArray = [MyList]()
        do {
            myListArray = try context.fetch(MyList.fetchRequest())
        } catch {
            print("Can't fetch core data items")
        }
        return myListArray
    }

    func add(myListObject: MyList) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Can't save core data item")
            }
        }
    }

    func remove(myListObject: MyList) {
        context.delete(myListObject)
        do {
            try context.save()
        } catch {
            print("Can't save my list item to core data!")
        }
    }

    func objectInMyList(id: Int) -> Bool {
        var items = [MyList]()
        let request = MyList.fetchRequest() as NSFetchRequest<MyList>
        let pred = NSPredicate(format: "id = \(id)")
        request.predicate = pred

        do {
            items = try context.fetch(request)
        } catch {
            print("Can't fetch item with predicate!")
        }

        if items.count > 0 {
            return true
        } else {
            return false
        }
    }
}
