# Document Management System

This project demonstrates the implementation of the Factory Method Pattern for a document management system.

## Design Pattern: Factory Method

The Factory Method Pattern is a creational design pattern that provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created.

## Project Structure

- `Document.java`: Interface defining common operations for all document types
- `WordDocument.java`, `PdfDocument.java`, `ExcelDocument.java`: Concrete implementations of Document interface
- `DocumentFactory.java`: Abstract factory class with factory method
- `WordDocumentFactory.java`, `PdfDocumentFactory.java`, `ExcelDocumentFactory.java`: Concrete factory implementations
- `App.java`: Main class to test the Factory Method Pattern

## Expected Output

```
Document Management System using Factory Method Pattern
---------------------------------------------------
Using Word Document:
Opening Word document
Saving Word document
Closing Word document

Using PDF Document:
Opening PDF document
Saving PDF document
Closing PDF document

Using Excel Document:
Opening Excel document
Saving Excel document
Closing Excel document

Using template method in DocumentFactory:
Opening Word document
Opening PDF document
Opening Excel document
```

## Pattern Implementation Details

1. **Document Interface**: Defines the common operations for all document types
2. **Concrete Document Classes**: Implement the Document interface with specific behavior
3. **Abstract Factory**: Provides a factory method for creating documents and a template method
4. **Concrete Factories**: Implement the factory method to create specific document types
