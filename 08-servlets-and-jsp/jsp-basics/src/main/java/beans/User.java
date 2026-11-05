package beans;

import java.io.Serializable;

/**
 * A simple JavaBean used by bean.jsp.
 *
 * A JavaBean must:
 *  - implement Serializable
 *  - have a public no-argument constructor
 *  - expose properties through getters and setters
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private String name;
    private int age;

    public User() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
