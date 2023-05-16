[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/hntwdd95)
# Pinpoint

Project for 420-431-VA

# Report
<kbd>

## Project Aim and Description
Our project is called PinPoint, it is an application that mainly focuses on making the user save a specific location. It was initially inspired to make people remember where they parked their car. Now, it makes it easier to make people remember and share their favorite locations. This app also provides a platform for users to message each other and post notes regarding a specific location. It also features having a user create an account and logging in.

## Functional and non-functional Requirements
For the functional requirements, mainly, the app must allow seamless transition to other pages. The application must allow users to own google accounts, sign in to google accounts, and register to google accounts. The users should also be able to pin locations, delete pins, search for locations, see all their pins in the map as well add notes to locations. Additionally, users must be able to message other users as well as add and unfriend them.

For the non-functional requirements the application must be easy to use, where every button implies its functionality. The app must also have a nice consistent design so all components looks coherent as well as work seamlessly among the other pages. Additionally the app also features simplistic navigation menu so that users are able to easily understand where to go.

## User Stories
Here is a list of user stories:
| nbr   | As A... | I want to...                                      | So that...                                            |
| :---: | :---:   | :---:                                             | :---:                                                 | 
| 1     | Guest   | Login the application using Google                | I get in the app                                      |
| 2     | User    | View nearby locations                             | I know where I can go next                            |
| 3     | User    | View a location on the map                        | I know where a location is on a map                   |
| 4     | User    | Pin a location                                    | I a location can be saved                             |
| 5     | User    | Share a location to a friend                      | My friend knows where I am                            |
| 6     | User    | View my pins                                      | I can see where all my pins are on the map            |
| 7     | User    | Remove a pin                                      | I can not be in that place anymore                    |
| 8     | User    | Search for locations by keywords                  | Searching for a location would become simpler         |
| 9     | User    | View my pins in a sorted way, by distance or name | Viewing the pins would become simopler                |
| 10    | User    | View my friend list                               | I can see my friends                                  |
| 11    | User    | Send friend requests                              | I can communicate with them                           |
| 12    | User    | Accept/decline friend requests                    | I know add people only I know                         |
| 13    | User    | View notes of a friend                            | I can see their opinion on a location                 |
| 14    | User    | Message a friend                                  | I can chat with them                                  |
| 15    | User    | Unfriend a friend                                 | I cannot communicate with them anymore                |
| 16    | User    | View my notes                                     | I can see my opinion on locations                     |
| 17    | User    | Clear all my pinpoints                            | I can start placing pins all over again               |
| 18    | User    | Delete all my notes                               | I can start placing notes all over again              |
| 19    | User    | Change my username                                | I can be called as something else                     |
| 20    | User    | Delete my account                                 | I can choose not to use the app anymore               |
| 21    | User    | Add notes to a location                           | I can place my opinion on a location                  |
| 22    | User    | View my friend's notes in a specific location     | I can see what he thinks about that specific location |
| 23    | User    | Logout the application                            | I can get out of the app                              |

## Tests
The unit tests are implemented in the `tests` folder. To run the tests, run `flutter test`. We are only using unit tests, which only test the functions that make the app work, but not the interactions with the UI and the database.

## Individual roles and Responsibilities
- **Jia Xuan Li**: Database connection and authentication, and unit tests.
- **Mert Salvador**: User interface design, notifications manager.

</kbd>