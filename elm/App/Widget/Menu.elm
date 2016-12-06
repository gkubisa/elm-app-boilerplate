module App.Widget.Menu exposing
  ( init, update, view
  , Model, Url, Msg, Config
  , createMenu, navigationLink, parentItem
  , defaultConfig, customConfig
  )

import Html exposing (ul, li, text, a, button, Html)
import Html.Attributes exposing (href, tabindex, class, classList)
import Html.Events exposing (onClick)

type alias Label = String
type alias Url = String

type MenuItem =
    NavigationLink
      { label: Label
      , url: Url
      }
  | ParentItem
      { label: Label
      , menuItems: List MenuItem
      }

type Menu =
  Menu (List MenuItem)

type alias Model =
  { menu: Menu
  , expandedParentItem: Maybe MenuItem
  }

type Msg =
    ActivateMenuItem MenuItem

type alias Config =
  { menuClass: String
  , subMenuClass: String
  , menuItemClass: String
  , navigationLinkClass: String
  , parentItemClass: String
  , activeClass: String
  , expandedClass: String
  }

defaultConfig: Config
defaultConfig = customConfig "Menu"

customConfig: String -> Config
customConfig baseClass =
  { menuClass = baseClass
  , subMenuClass = baseClass ++ "_subMenu"
  , menuItemClass = baseClass ++ "_item"
  , activeClass = baseClass ++ "_item-active"
  , expandedClass = baseClass ++ "_item-expanded"
  , navigationLinkClass = baseClass ++ "_navigationLink"
  , parentItemClass = baseClass ++ "_parentItem"
  }

init: Menu -> (Model, Cmd Msg)
init menu =
  ( { menu = menu
    , expandedParentItem = Nothing
    }
  , Cmd.none
  )

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    maybeExpandedItem = model.expandedParentItem
    allItems = getItems model.menu
  in
    case msg of
      ActivateMenuItem activatedItem ->
        case activatedItem of
          ParentItem _ ->
            if isJustMember maybeExpandedItem [activatedItem]
              then
                -- an active item was activated, so expand its parent
                ( { model
                  | expandedParentItem = findParent activatedItem allItems
                  }
                , Cmd.none)
              else
                -- an inactive item was activated, so expand it
                ( { model
                  | expandedParentItem = Just activatedItem
                  }
                , Cmd.none)
          _ ->
            -- let the browser handle activation of the `NavigationLink`
            (model, Cmd.none)

view: Config -> Model -> Url -> Html Msg
view config model activeUrl =
  let
    menu = model.menu
    maybeExpandedItem = model.expandedParentItem

    menuView (Menu menuItems) =
      menuItemsView [ class config.menuClass ] menuItems

    menuItemsView attributes menuItems =
      ul attributes <| List.map menuItemView menuItems

    menuItemView menuItem =
      case menuItem of
        NavigationLink { label, url } ->
          let
            classAttribute = classList
              [ (config.menuItemClass, True)
              , (config.activeClass, isActive activeUrl menuItem)
              ]
          in
            li [ classAttribute ]
              [ a [ class config.navigationLinkClass
                  , href url
                  ]
                  [ text label ]
              ]
        ParentItem { label, menuItems } ->
          let
            classListAttribute = classList
              [ (config.menuItemClass, True)
              , (config.expandedClass, isJustMember maybeExpandedItem [menuItem])
              , (config.activeClass, isActive activeUrl menuItem)
              ]
          in
            li [ classListAttribute ]
              [ button
                  [ class config.parentItemClass
                  , onClick (ActivateMenuItem menuItem)
                  ]
                  [ text label ]
              , menuItemsView [ class config.subMenuClass ] menuItems
              ]
  in
    menuView menu

createMenu: List MenuItem -> Menu
createMenu items =
  Menu items

getItems: Menu -> List MenuItem
getItems (Menu menuItems) =
  menuItems

navigationLink: Label -> Url -> MenuItem
navigationLink label url =
  NavigationLink
    { label = label
    , url = url
    }

parentItem: Label -> List MenuItem -> MenuItem
parentItem label menuItems =
  ParentItem
    { label = label
    , menuItems = menuItems
    }

{-| Recursively searches the provided list, and returns the first item matching
the predicate.
-}
findMenuItem: (MenuItem -> Bool) -> List MenuItem -> Maybe MenuItem
findMenuItem predicate items =
  case items of
    item :: remainingItems ->
      if predicate item then
        Just item
      else
        case item of
          ParentItem { menuItems } ->
            case findMenuItem predicate menuItems of
              Just _ as foundItem ->
                foundItem
              Nothing ->
                findMenuItem predicate remainingItems
          _ ->
            findMenuItem predicate remainingItems
    [] ->
      Nothing

{-| Recursively searches the provided list, and returns true, if any of the
menu items matches the predicate.
-}
anyMenuItem: (MenuItem -> Bool) -> List MenuItem -> Bool
anyMenuItem predicate items =
  case findMenuItem predicate items of
    Just _ ->
      True
    _ ->
      False

{-| Determines if the second menu item is the parent of the first menu item.
-}
isParentOf: MenuItem -> MenuItem -> Bool
isParentOf childItem parentItem =
  case parentItem of
    ParentItem { menuItems } ->
      List.member childItem menuItems
    _ ->
      False

{-| Recursively checks, if `item` is a member of the specified list.
-}
isMember: MenuItem -> List MenuItem -> Bool
isMember item =
  anyMenuItem ((==) item)

{-| Recursively checks, if the item inside `maybeItem` is a member of the
specified list.
-}
isJustMember: Maybe MenuItem -> List MenuItem -> Bool
isJustMember maybeItem menuItems =
  case maybeItem of
    Just item ->
      isMember item menuItems
    _ ->
      False

{-| Recursively searches for the parent of `childItem`.
-}
findParent: MenuItem -> List MenuItem -> Maybe MenuItem
findParent childItem =
  findMenuItem (isParentOf childItem)

{-| Determines, if the specified menu item is active.
-}
isActive: Url -> MenuItem -> Bool
isActive activeUrl checkedItem =
  case checkedItem of
    NavigationLink { url } ->
      activeUrl == url
    ParentItem { menuItems } ->
      anyMenuItem (isActive activeUrl) menuItems
