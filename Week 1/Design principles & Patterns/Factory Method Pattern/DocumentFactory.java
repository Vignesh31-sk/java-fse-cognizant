/**
 * Abstract Document Factory with factory method createDocument()
 */
public abstract class DocumentFactory {
    /**
     * Factory method to create a document
     * 
     * @return Document instance
     */
    public abstract Document createDocument();

    /**
     * Template method that uses the factory method
     */
    public void openDocument() {
        Document document = createDocument();
        document.open();
    }
}
