module ChatsHelper

	def display_messagem_sistem(texto,qnt)
		if texto.length <= qnt
		 	raw(texto)
		else 
		  	raw(texto[0..qnt]+" ... ")
		end
	end	
end
