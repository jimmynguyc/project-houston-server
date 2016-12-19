# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

doc = File.open(Dir.pwd + '/db/IR_signal.txt')
txt = ""
doc.each do |line|
	txt = txt + line
end

#arr = []
#txt.split('name').each{|el| arr << el.split(' ')}

byebug
txt.split(/\n\n/).each do |cmd_signal|
	InfraredSignal.create(command:cmd_signal.split(' ')[1],ir_signal_in_conf:cmd_signal)
end

