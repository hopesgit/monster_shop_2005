## Monster Shop

Monster Shop is a representation of a large-scale, e-commerce web site. The site serves individual users, administrators, and merchants, along with their respective merchant stores. The application attempts to replicate the experience that each type of user may encounter as they interact with a real-world merchant retail site.


## Schema

![alt text](https://user-images.githubusercontent.com/58994078/98318659-4e109180-1f9c-11eb-9be6-a84f37d52b0f.png)

## User Roles

**Visitor / User** - A Visitor has the ability to browse the site and its individual merchant stores. In order to add items to a cart and make a purchase, the Visitor must be logged into an active User account. If the Visitor does not have an account, one must be created with personal information and a unique email address and password. 

**Merchant** - A Merchant user has the ability to fufill orders, create/update/delete items, update merchant information, and just like a logged-in User, they can add/delete items to a cart and check out.

**Admin** - An Admin user has access to all areas of the site, and the authority to ship and cancel orders.

## Learning Goals

**Database**

-Created Schema

-Designed One-to-Many, Many-to-Many Relationships

**Active Record** 

-Joined multiple tables of data

-Utilized queries to calulate and group data based on mulitple attributes

**Authentication and Authorization**

-Namespaced Routes

-Used Sessions for login/logout functionality

-Used Sessions for storing information

-Limited functionality to authorized users

-Used BCrypt to hash user passwords

**Rails**

-Used filters in Rails controller (before_action)

-Followed MVC principles

-Utitlized and followed basic HTML and CSS conventions to render view templates

## Screenshots

![image](https://user-images.githubusercontent.com/66448493/98321252-d80f2900-1fa1-11eb-9117-f06573eb9ad0.png)

![image](https://user-images.githubusercontent.com/66448493/98320969-3daee580-1fa1-11eb-94d8-dbbd353d7475.png)

![image](https://user-images.githubusercontent.com/66448493/98320900-1bb56300-1fa1-11eb-9959-e0d701b925b6.png)

![image](https://user-images.githubusercontent.com/66448493/98321071-6a62fd00-1fa1-11eb-9ca9-37c263212108.png)

![image](https://user-images.githubusercontent.com/66448493/98321201-b0b85c00-1fa1-11eb-9561-f963fdd24560.png)




## Rubric

| | **Feature Completeness** | **Rails** | **ActiveRecord** | **Testing and Debugging** | **Documentation** |
| --- | --- | --- | --- | --- | --- |
| **4: Exceptional**  | All User Stories 100% complete including all sad paths and edge cases, and some extension work completed | Students implement strategies not discussed in class to effectively organize code and adhere to MVC. | Highly effective and efficient use of ActiveRecord beyond what we've taught in class. Even `.each` calls will not cause additional database lookups. | Very clear Test Driven Development. Test files are extremely well organized and nested. Students utilize `before :each` blocks. 100% coverage for features and models. Close to all edge cases are accounted for.| Final project has a well written README with pictures, schema design, code snippets, contributors names linked to their github profile, heroku link, and implementation instructions. |
| **3: Passing** | Students complete all User Stories. No more than 2 Stories fail to correctly implement sad path and edge case functionality. | Students use the principles of MVC to effectively organize code. Students can defend any of their design decisions. Students limit access to authorized users. | ActiveRecord is used in a clear and effective way to read/write data using no Ruby to process data. | 100% coverage for models. 98% coverage for features. Tests are well written and meaningful. | Students have a README with thorough implementation instructions and description of content. |
| **2: Passing with Concerns** | Students complete all but 1 - 3 User Stories | Students utilize MVC to organize code, but cannot defend some of their design decisions. Or some functionality is not limited to the appropriately authorized users. | Ruby is used to process data that could use ActiveRecord instead. | Feature test coverage between 90% and 98%, or model test coverage below 100%, or tests are not meaningfully written or have an unclear objective. | Students have a README but it is not thorough in describing the implementation or content of the project. |
| **1: Failing** | Students fail to complete 4 or more User Stories | Students do not effectively organize code using MVC. Or students do not authorize users. | Ruby is used to process data more often than ActiveRecord | Below 90% coverage for either features or models. | Students did not create their own README. |
