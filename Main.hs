import App.Menus.MenuManager (menuInicial)

main :: IO()
main = do
    menuInicial
    createMovie "usuario1" "Filme 1" "Diretor 1" 150 "Drama" 6.8