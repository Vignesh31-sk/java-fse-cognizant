public class App {
    public static void main(String[] args) {
        System.out.println("Document Management System using Factory Method Pattern");
        System.out.println("---------------------------------------------------");

        // Create Word document using factory
        DocumentFactory wordFactory = new WordDocumentFactory();
        Document wordDoc = wordFactory.createDocument();
        System.out.println("Using Word Document:");
        wordDoc.open();
        wordDoc.save();
        wordDoc.close();
        System.out.println();

        // Create PDF document using factory
        DocumentFactory pdfFactory = new PdfDocumentFactory();
        Document pdfDoc = pdfFactory.createDocument();
        System.out.println("Using PDF Document:");
        pdfDoc.open();
        pdfDoc.save();
        pdfDoc.close();
        System.out.println();

        // Create Excel document using factory
        DocumentFactory excelFactory = new ExcelDocumentFactory();
        Document excelDoc = excelFactory.createDocument();
        System.out.println("Using Excel Document:");
        excelDoc.open();
        excelDoc.save();
        excelDoc.close();

        // Using the template method from DocumentFactory
        System.out.println("\nUsing template method in DocumentFactory:");
        wordFactory.openDocument();
        pdfFactory.openDocument();
        excelFactory.openDocument();
    }
}
