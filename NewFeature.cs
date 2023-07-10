namespace Name1
{
    public record Person(string name, string lastName, string jobTitle);

    public record Employee(string name, string lastName, string jobTitle);

    public record Student(string name, string lastName, string facultyTitle);

    public record Manager(string name, string lastName, double salary);

    public record Supervisor(string name, string lastName, string nickname);
}