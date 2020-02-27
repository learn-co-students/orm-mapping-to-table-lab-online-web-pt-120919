class Student

	attr_accessor :name, :grade
	attr_reader :id

	def initialize(name, grade, id = nil)
		@name = name
		@grade = grade
		@id = id
	end

	def save
		sql = <<-SQL
			INSERT INTO students (name, grade)
			VALUES (?, ?)
		SQL
		DB[:conn].execute(sql, self.name, self.grade)

		sql = <<-SQL
			SELECT last_insert_rowid() FROM students
		SQL
		@id = DB[:conn].execute(sql).flatten.first
	end

	def self.create(args)
		student = new(args[:name], args[:grade])
		student.save
		student
	end

	def self.create_table
		sql = <<-SQL
			CREATE TABLE IF NOT EXISTS students (
				id INTEGER PRIMARY KEY,	
				name TEXT,
				grade TEXT
			);
		SQL
		DB[:conn].execute(sql)
	end

	def self.drop_table
		sql = <<-SQL
			DROP TABLE IF EXISTS students;
		SQL
		DB[:conn].execute(sql)
	end


end
