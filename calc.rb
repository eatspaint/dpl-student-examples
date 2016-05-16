while true #sloppy low-liner code. DO NOT TRY TO BE LIKE THIS. IT IS BAD.
  print "Enter a calculation, put spaces between that shit ('q' to quit): "
  calc = gets.strip.split(' ')
  calc == ['q'] ? exit(0) : (puts ['+', '-', '/', '*'].include?(calc[1]) ? calc[0].to_i.send(calc[1].to_sym, calc[2].to_i) : "fucked up")
end
