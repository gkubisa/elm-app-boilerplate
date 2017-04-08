module App.Widget.Menu
    exposing
        ( init
        , update
        , view
        , Model
        , Msg
        , Config
        , Url
        , Label
        , navigationLink
        , parentItem
        , defaultConfig
        , customConfig
        )

import App.Widget.Menu.Style exposing (namespace, CssClass(..))
import Html exposing (ul, li, text, a, button, Html)
import Html.Attributes exposing (href)
import Html.CssHelpers exposing (Namespace)
import Html.Events exposing (onClick)


type alias Label =
    String


type alias Url =
    String


type alias MenuItems =
    List MenuItem


type MenuItem
    = NavigationLink
        { label : Label
        , url : Url
        }
    | ParentItem
        { label : Label
        , menuItems : MenuItems
        }


type Model
    = Model
        { menuItems : MenuItems
        , expandedParentItem : Maybe MenuItem
        }


type Msg
    = ActivateMenuItem MenuItem


type Config
    = Config
        { namespace : Namespace String CssClass Never Msg
        }


defaultConfig : Config
defaultConfig =
    customConfig namespace


customConfig : Namespace String CssClass Never Msg -> Config
customConfig namespace =
    Config
        { namespace = namespace
        }


init : MenuItems -> ( Model, Cmd Msg )
init menuItems =
    ( Model
        { menuItems = menuItems
        , expandedParentItem = Nothing
        }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        ActivateMenuItem activatedItem ->
            case activatedItem of
                ParentItem _ ->
                    if isJustMember model.expandedParentItem [ activatedItem ] then
                        -- an active item was activated, so expand its parent
                        ( Model
                            { model
                                | expandedParentItem =
                                    findParent activatedItem model.menuItems
                            }
                        , Cmd.none
                        )
                    else
                        -- an inactive item was activated, so expand it
                        ( Model
                            { model
                                | expandedParentItem = Just activatedItem
                            }
                        , Cmd.none
                        )

                NavigationLink _ ->
                    -- collapse the menu and let the browser handle the navigation
                    ( Model
                        { model
                            | expandedParentItem = Nothing
                        }
                    , Cmd.none
                    )


view : Config -> Model -> Url -> Html Msg
view (Config config) (Model model) activeUrl =
    let
        { class, classList } =
            config.namespace

        menuItemsView level expanded menuItems =
            ul
                [ classList
                    [ ( Menu, level == 1 )
                    , ( Menu_List, True )
                    , ( Menu_List_level level, True )
                    , ( Menu_List_expanded, expanded )
                    ]
                ]
            <|
                List.map (menuItemView level) menuItems

        menuItemView level menuItem =
            let
                itemClass =
                    class
                        [ Menu_Item
                        , Menu_Item_level level
                        ]

                contentClass =
                    classList
                        [ ( Menu_Content, True )
                        , ( Menu_Content_level level, True )
                        , ( Menu_Content_active, isActive activeUrl menuItem )
                        ]

                clickHandler =
                    onClick (ActivateMenuItem menuItem)
            in
                case menuItem of
                    NavigationLink { label, url } ->
                        li [ itemClass ]
                            [ a
                                [ contentClass
                                , clickHandler
                                , href url
                                ]
                                [ text label ]
                            ]

                    ParentItem { label, menuItems } ->
                        let
                            expanded =
                                isJustMember model.expandedParentItem [ menuItem ]
                        in
                            li [ itemClass ]
                                [ button
                                    [ contentClass
                                    , clickHandler
                                    ]
                                    [ text label ]
                                , menuItemsView (level + 1) expanded menuItems
                                ]
    in
        menuItemsView 1 True model.menuItems


navigationLink : Label -> Url -> MenuItem
navigationLink label url =
    NavigationLink
        { label = label
        , url = url
        }


parentItem : Label -> MenuItems -> MenuItem
parentItem label menuItems =
    ParentItem
        { label = label
        , menuItems = menuItems
        }


{-| Recursively searches the provided list, and returns the first item matching
the predicate.
-}
findMenuItem : (MenuItem -> Bool) -> MenuItems -> Maybe MenuItem
findMenuItem predicate items =
    case items of
        item :: remainingItems ->
            if predicate item then
                Just item
            else
                case item of
                    ParentItem { menuItems } ->
                        case findMenuItem predicate menuItems of
                            (Just _) as foundItem ->
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
anyMenuItem : (MenuItem -> Bool) -> MenuItems -> Bool
anyMenuItem predicate items =
    case findMenuItem predicate items of
        Just _ ->
            True

        _ ->
            False


{-| Determines if the second menu item is the parent of the first menu item.
-}
isParentOf : MenuItem -> MenuItem -> Bool
isParentOf childItem parentItem =
    case parentItem of
        ParentItem { menuItems } ->
            List.member childItem menuItems

        _ ->
            False


{-| Recursively checks, if `item` is a member of the specified list.
-}
isMember : MenuItem -> MenuItems -> Bool
isMember item =
    anyMenuItem ((==) item)


{-| Recursively checks, if the item inside `maybeItem` is a member of the
specified list.
-}
isJustMember : Maybe MenuItem -> MenuItems -> Bool
isJustMember maybeItem menuItems =
    case maybeItem of
        Just item ->
            isMember item menuItems

        _ ->
            False


{-| Recursively searches for the parent of `childItem`.
-}
findParent : MenuItem -> MenuItems -> Maybe MenuItem
findParent childItem =
    findMenuItem (isParentOf childItem)


{-| Determines, if the specified menu item is active.
-}
isActive : Url -> MenuItem -> Bool
isActive activeUrl checkedItem =
    case checkedItem of
        NavigationLink { url } ->
            activeUrl == url

        ParentItem { menuItems } ->
            anyMenuItem (isActive activeUrl) menuItems
