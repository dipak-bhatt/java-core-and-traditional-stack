package crud;

import java.util.ArrayList;
import java.util.List;

/**
 * In-memory DAO used by student_crud.jsp so the example runs without a database.
 *
 * The BCAVI reference project uses the same method names against Oracle:
 *
 *   jdbc:oracle:thin:@localhost:1521:XE
 *   table: studentInformation (id, name, email, country)
 *
 * To use a real database, replace the body of these methods with the JDBC
 * code from the reference DataAccess class.
 */
public class DataAccess {

    private static final List<StudentInformation> STUDENTS = new ArrayList<>();
    private static int nextId = 1;

    static {
        STUDENTS.add(new StudentInformation(nextId++, "Aarav", "aarav@example.com", "India"));
        STUDENTS.add(new StudentInformation(nextId++, "Maya", "maya@example.com", "Nepal"));
    }

    public DataAccess() {
    }

    public void insertUser(StudentInformation student) {
        synchronized (STUDENTS) {
            student.setId(nextId++);
            STUDENTS.add(student);
        }
    }

    public StudentInformation selectStudent(int id) {
        synchronized (STUDENTS) {
            for (StudentInformation student : STUDENTS) {
                if (student.getId() == id) {
                    return student;
                }
            }
            return null;
        }
    }

    public List<StudentInformation> selectAllStudents() {
        synchronized (STUDENTS) {
            return new ArrayList<>(STUDENTS);
        }
    }

    public boolean deleteStudent(int id) {
        synchronized (STUDENTS) {
            return STUDENTS.removeIf(student -> student.getId() == id);
        }
    }

    public boolean updateStudent(StudentInformation updated) {
        synchronized (STUDENTS) {
            for (StudentInformation student : STUDENTS) {
                if (student.getId() == updated.getId()) {
                    student.setName(updated.getName());
                    student.setEmail(updated.getEmail());
                    student.setCountry(updated.getCountry());
                    return true;
                }
            }
            return false;
        }
    }
}
