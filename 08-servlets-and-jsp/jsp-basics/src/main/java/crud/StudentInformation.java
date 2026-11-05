package crud;

/**
 * Model class used by student_crud.jsp.
 * Mirrors crud.StudentInformation from the BCAVI reference project.
 */
public class StudentInformation {
    protected int id;
    protected String name;
    protected String email;
    protected String country;

    public StudentInformation() {
    }

    public StudentInformation(String name, String email, String country) {
        this.name = name;
        this.email = email;
        this.country = country;
    }

    public StudentInformation(int id, String name, String email, String country) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.country = country;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }
}
