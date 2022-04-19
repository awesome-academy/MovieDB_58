import Foundation
import CoreData

extension MyList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyList> {
        return NSFetchRequest<MyList>(entityName: "MyList")
    }

    @NSManaged public var id: Int
    @NSManaged public var name: String?
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var isMovie: Bool

}

extension MyList: Identifiable {

}
