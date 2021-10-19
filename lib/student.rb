require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :id
  def initialize(name, grade, id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE if NOT EXISTS students(
    id INTEGER PRIAMRYKEY,
    name TEXT,
    grade TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
   INSERT INTO students(name, grade)
   VALUES(?,?)
   SQL
   DB[:conn].execute(sql, self.name, self.grade)
   self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
   self
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    # binding.pry
    create(row[1], row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    SQL
    row = DB[:conn].execute(sql, name)
    self.new_from_db(row)
  end


  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
