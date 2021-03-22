module OldAppCsvImport

	require 'csv'

	# reference, firstname, lastname, home_phone_number, mobile_phone_number, email, address | n=7
	def self.import_people(csv_path="people.csv")
		import(csv_path, person)
	end

	# reference, address, zip_code, city, country, manager_name | n=6
	def self.import_building(csv_path="buildings.csv")
		import(csv_path, building)
	end

	def self.import_all(csv_buildings, csv_people)
			self.import_building(csv_buildings)
			self.import_person(csv_people)
	end


private

def import(csv_path, proc)
	parsed = 0
	updated = 0
	csv = CSV.foreach(csv_path, headers: true)
	csv.each &proc
	p "#{parsed} éléments parcourus, #{updated} éléments mis à jour"
end

def check(x, y, z)
	if x.method(y).call != z
		x.send(y+'=', z)
	end
end

person = Proc.new do |person|
	change = false
	if x = Person.find(person.field("reference").to_i)
		x.firstname = person.field("firstname")
		x.lastname = person.field("lastname")
		check(x, 'home_phone_number', person.field("home_phone_number"))
		check(x, 'mobile_phone_number', person.field("mobile_phone_number"))
		check(x, 'email', person.field("email"))
		check(x, 'address', person.field("address"))
		change = true
	end
	parsed += 1
	if change
		x.save
		updated += 1 
	end
end

building = Proc.new do |building|
	change = false
	if x = Buildind.find(building.field("reference").to_i)
		x.address = building.field("address")
		x.zip_code = building.field("zip_code")
		x.city = building.field("city")
		x.country = building.field("country")
		check(x, 'manager_name', building.field("manager_name"))
		change = true
	end
	parsed += 1
	if change
		x.save
		updated += 1 
	end
end

end