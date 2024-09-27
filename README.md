# Expense-tracker
This project enables efficient tracking of financial transactions, allowing users to save each movement in a local database. Every transaction can be tagged, named, or further described for enhanced organization and clarity.
Although simple in its design, this project gave me the opportunity to start working with Flutter’s database packages, particularly Isar.

## Database

The project leverages the Isar package for database management. Isar is a noSQL database that enables the storage of schemas, which correspond to the classes used within the application. To use this database, schemas must be initialized with tags such as:
```dart
@collection
Class collectionName {}
```
This setup allows the ``build_runner`` package to generate the necessary code for the database to function. 
Isar offers extensive filtering options and, according to its website, its very fast. However, due to the simplicity of my current application structure, i haven't yet been able to fully test its performance



## Testing

As part of this project, I explored Flutter's integration test features and packages. While i have previously worked with unit tests but they have limitations in scope. Integration testing, on the other hand, allows you to simulate real-world user interactions, providing a more comprehensive testing experience.

The test files are located in the ``./integration_test`` folder. Unfortunately, due to changes in the application, these tests may not currently function correctly, as they were written for an earlier version of the project.

