 
import Foundation
import MusicAPI
 
 protocol SearchPresenterProtocol: AnyObject {
 func music(_ index: Int) -> MusicResult?
 func numberOfItems() -> Int
 func didSelectRowAt(index: Int)
 func viewDidLoad()
 func getMusic(with searchText: String)

 }

 final class SearchPresenter {
    
     unowned var view: SearchViewControllerProtocol
     let router: SearchRouterProtocol!
     let interactor: SearchInteractorProtocol!
     
     private var music: [MusicResult] = []
     
     
 init(
     view: SearchViewControllerProtocol,
     router: SearchRouterProtocol,
     interactor: SearchInteractorProtocol)
 {
     self.view = view
     self.router = router
     self.interactor = interactor
 }
 }

extension SearchPresenter: SearchPresenterProtocol {
    func viewDidLoad() {
        view.setTitle("iTunes")
        view.configureSearchBar()
        view.configureTableView()
        let searchText = view.getSearchText()
        getMusic(with: searchText)
    }
    
    func getMusic(with searchText: String) {
        view.showLoadingView()
        interactor.getMusics(with: searchText)

    }
     
     func music(_ index: Int) -> MusicResult? {
         return music[safe: index]
     }
    func numberOfItems() -> Int {
        music.count
    }
     
     func didSelectRowAt(index: Int) {
         guard let source = music(index) else { return }
         router.navigate(.detail(source: source))
     }
 }

extension SearchPresenter: SearchInteractorOutputProtocol {
    
    func fetchMusicsOutput(_ result: MusicsSourcesResult) {
        
        view.hideLoadingView()
        
        switch result {
        case .success(let musicResult):
            self.music = musicResult
            view.update(with: musicResult)
        case .failure:
            view.showError("Something went wrong")
        }
    }
 }

 
 

