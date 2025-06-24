import java.lang.reflect.Array;
import java.util.ArrayList;

public class App {
    public static void main(String[] args) throws Exception {
        ArrayList<Product> products = new ArrayList<>();
        products.add(new Product("1", "Electronics", "Smartphone"));
        products.add(new Product("2", "Electronics", "Laptop"));
        products.add(new Product("3", "Home Appliances", "Refrigerator"));
        products.add(new Product("4", "Electronics", "Smartwatch"));
        products.add(new Product("5", "Home Appliances", "Washing Machine"));

        // Linear Search
        String searchId = "3";
        int linearIndex = linearSearch(products, searchId);
        if (linearIndex != -1) {
            System.out.println("Linear Search: Product found at index " + linearIndex + " with ID " + searchId);
        } else {
            System.out.println("Linear Search: Product with ID " + searchId + " not found.");
        }

        // Binary Search
        String searchName = "Smartwatch";
        int binaryIndex = binarySearch(products, searchName);

        if (binaryIndex != -1) {
            System.out.println("Binary Search: Product found at index " + binaryIndex + " with name " + searchName);
        } else {
            System.out.println("Binary Search: Product with name " + searchName + " not found.");
        }

        // Display all products
        System.out.println("All Products:");
        for (Product product : products) {
            System.out.println("ID: " + product.id + ", Category: " + product.category + ", Name: " + product.name);
        }
    }

    public static int linearSearch(ArrayList<Product> products, String id) {

        for (int i = 0; i < products.size(); i++) {
            if (products.get(i).id == id)
                return i;
        }

        return -1;
    }

    public static int binarySearch(ArrayList<Product> products, String name) {
        products.sort((p1, p2) -> p1.name.compareToIgnoreCase(p2.name));
        int left = 0, right = products.size() - 1;

        while (left <= right) {
            int mid = left + (right - left) / 2;
            int compare = products.get(mid).name.compareToIgnoreCase(name);

            if (compare == 0)
                return mid;
            else if (compare < 0)
                left = mid + 1;
            else
                right = mid - 1;
        }
        return -1;
    }

}

class Product {
    String id;
    String category;
    String name;

    public Product(String id, String category, String name) {
        this.id = id;
        this.category = category;
        this.name = name;
    }

}
