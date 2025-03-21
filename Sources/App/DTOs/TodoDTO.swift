import Fluent
import Vapor

struct TodoDTO: Content {
    var id: UUID?
    var title: String?
    
    func toModel() -> CardModels {
        let model = CardModels()
        
        model.id = self.id
        
        return model
    }
}
