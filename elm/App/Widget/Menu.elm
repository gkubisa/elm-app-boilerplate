-- TODO use lazy

module App.Widget.Menu exposing
  ( init, update, urlUpdate, view
  , Model, Msg
  , createMenu, createInternalLink, createExternalLink, createParentItem
  )

import Html exposing (ul, li, text, a, button, Html)
import Html.Attributes exposing (href, tabindex, class, classList)
import Erl
import App.AppRoute as AppRoute exposing (Route, newRoute)
import App.Util.Html.Events exposing (onClick)

type alias Label = String

type MenuItem =
    InternalLink
      { label: Label
      , route: Route
      }
  | ExternalLink
      { label: Label
      , url: Erl.Url
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
  , activeRoute: Route
  }

type Msg =
    ActivateMenuItem MenuItem

init: Route -> Menu -> (Model, Cmd Msg)
init activeRoute menu =
  ( { menu = menu
    , expandedParentItem = Nothing
    , activeRoute = activeRoute
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
          InternalLink { route } ->
            -- navigate to the InternalLink
            (model, newRoute route)
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
          ExternalLink _ ->
            -- let the browser handle activation of the `ExternalLink`
            (model, Cmd.none)

urlUpdate: Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
  ( { model
    | activeRoute = route
    }
  , Cmd.none
  )

view: Model -> Html Msg
view model =
  let
    menu = model.menu
    maybeExpandedItem = model.expandedParentItem
    activeRoute = model.activeRoute

    menuView (Menu menuItems) =
      menuItemsView [ class "App-Widget-Menu" ] menuItems

    menuItemsView attributes menuItems =
      ul attributes <| List.map menuItemView menuItems

    menuItemView menuItem =
      case menuItem of
        InternalLink { label, route } ->
          let
            classAttribute = classList
              [ ("active", isActive activeRoute menuItem)
              ]
          in
            li [ classAttribute ]
              [ a [ href (AppRoute.toString route)
                  , onClick (ActivateMenuItem menuItem)
                  ]
                  [ text label ]
              ]
        ExternalLink { label, url } ->
          li []
            [ a [ href (Erl.toString url) ]
                [ text label ]
            ]
        ParentItem { label, menuItems } ->
          let
            classListAttribute = classList
              [ ("expanded", isJustMember maybeExpandedItem [menuItem])
              , ("active", isActive activeRoute menuItem)
              ]
          in
            li [ classListAttribute ]
              [ button
                  [ onClick (ActivateMenuItem menuItem) ]
                  [ text label ]
              , menuItemsView [] menuItems
              ]
  in
    menuView menu

createMenu: List MenuItem -> Menu
createMenu items =
  Menu items

getItems: Menu -> List MenuItem
getItems (Menu menuItems) =
  menuItems

createInternalLink: Label -> Route -> MenuItem
createInternalLink label route =
  InternalLink
    { label = label
    , route = route
    }

createExternalLink: Label -> Erl.Url -> MenuItem
createExternalLink label url =
  ExternalLink
    { label = label
    , url = url
    }

createParentItem: Label -> List MenuItem -> MenuItem
createParentItem label menuItems =
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
isActive: Route -> MenuItem -> Bool
isActive activeRoute checkedItem =
  case checkedItem of
    InternalLink { route } ->
      activeRoute == route
    ParentItem { menuItems } ->
      anyMenuItem (isActive activeRoute) menuItems
    _ ->
      False
