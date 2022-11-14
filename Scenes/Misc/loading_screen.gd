extends Control

onready var label = $ColorRect/Label
onready var texture_progress = $ColorRect/CenterContainer/VBoxContainer/TextureProgress

onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

onready var tips: Array = [
	"The floor is made out of floor.",
	"Collision shapes in this game are really weird, try not to get hit through a wall.",
	"Long weapons have a range advantage, but do less damage.",
	"Dying often? Sucks to be you.",
	"This game was made by Rektagon and some guy named Scottie.",
	"Check out Blooket! They were the inspiration for this game.",
	"Soul Knight is also pretty cool.",
	"Any weapons that you'd like to see in the future? Fork the game from Github and mod it! We might add it if you merge it back.",
	"There's no real limit to how long these can be. So uhh... Memories broken; the truth goes unspoken; I've even forgotten my name. I don't know the season, or what is the reason, I'm standing here holding my blade. A desolate place, without any trace, it's only the cold wind I feel. It's me that I spite as I stand up and fight, the only thing I know for real. There will be blood(shed), the man in the mirror nods his head. The only one left will ride upon the dragon's back, because the mountains don't give back what they take. Oh no, there will be blood(shed), the only thing i've ever known. - Everyone's favorite Brazilian swordsman",
	"How many anime tropes did you count in this game?",
	"Wastelands is best played when you're trying to study.",
	"Mitochondria is the powerhouse of the cell.",
	"Firearms are very effective against most classes of enemies, except for armored ones.",
	"Some rooms are laid out like a maze. Use that to your advantage.",
	"Getting lost in the dungeon isn't that fun, honestly. Try to remember your path.",
	"Loading screen tips are always garbage. So, subscribe.",
	"You can find random weapons in the rooms sometimes.",
	"Don't like having to answer questions? Well too bad, you downloaded this game for the express purpose of studying.",
	"There are many interesting reactions when you combine weapons. Try and find them all!",
	"My fingers are tired.",
	"Maybe I should make a Blooket Tower Defense, but better.",
	"Bloons supremacy.",
	"I actually wrote a lot of these tips when the game was in a super early stage, so a lot of them will probably be inaccurate :P",
	"Poaceae (/poʊˈeɪsiaɪ/) or Gramineae (/ɡrəˈmɪniaɪ/) is a large and nearly ubiquitous family of monocotyledonous flowering plants commonly known as grasses. It includes the cereal grasses, bamboos and the grasses of natural grassland and species cultivated in lawns and pasture. The latter are commonly referred to collectively as grass.With around 780 genera and around 12,000 species,[4] the Poaceae is the fifth-largest plant family, following the Asteraceae, Orchidaceae, Fabaceae and Rubiaceae.[5] The Poaceae are the most economically important plant family, providing staple foods from domesticated cereal crops such as maize, wheat, rice, barley, and millet as well as feed for meat-producing animals. They provide, through direct human consumption, just over one-half (51%) of all dietary energy; rice provides 20%,[6] wheat supplies 20%, maize (corn) 5.5%, and other grains 6%[citation needed]. Some members of the Poaceae are used as building materials (bamboo, thatch, and straw); others can provide a source of biofuel, primarily via the conversion of maize to ethanol.Grasses have stems that are hollow except at the nodes and narrow alternate leaves borne in two ranks. The lower part of each leaf encloses the stem, forming a leaf-sheath. The leaf grows from the base of the blade, an adaptation allowing it to cope with frequent grazing.Grasslands such as savannah and prairie where grasses are dominant are estimated to constitute 40.5% of the land area of the Earth, excluding Greenland and Antarctica.[7] Grasses are also an important part of the vegetation in many other habitats, including wetlands, forests and tundra.Though they are commonly called 'grasses', groups such as the seagrasses, rushes and sedges fall outside this family. The rushes and sedges are related to the Poaceae, being members of the order Poales, but the seagrasses are members of order Alismatales. However, all of them belong to the monocot group of plants.",
	"Did you enjoy that wikipedia article?"
]

func _ready() -> void:
	rng.randomize()
	$Timer.start()
	label.text = tips[int(rng.randf_range(0,tips.size()))]


func _on_Timer_timeout():
	label.text = tips[int(rng.randf_range(0,20))]
	$Timer.start()
