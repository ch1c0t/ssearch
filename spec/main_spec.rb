require 'wrong/assert'
require 'ssearch'
require 'gutenberg/book'

include Wrong::Assert
include Ssearch

begin 
  R = Redis.new
  ROOT = 'spec/data'
  foreman_pid = fork { exec "foreman start -d spec" }
  sleep 0.5

  include Wrong::Assert
  include Ssearch

  documents = Dir["#{ROOT}/*.txt"].map { |file| Gutenberg::Book.new_from_txt file }
  fronts = documents.map { |document| Front.new "#{ROOT}/db#{document.__id__}", document}
  front = fronts[2]

  expected = [
      "At last the Mouse, who seemed to be a person of authority among them, called out, 'Sit down, all of you, and listen to me! I'LL soon make you dry enough!' They all sat down at once, in a large ring, with the Mouse in the middle. Alice kept her eyes anxiously fixed on it, for she felt sure she would catch a bad cold if she did not get dry very soon.",
      "'It was much pleasanter at home,' thought poor Alice, 'when one wasn't always growing larger and smaller, and being ordered about by mice and rabbits. I almost wish I hadn't gone down that rabbit-hole--and yet--and yet--it's rather curious, you know, this sort of life! I do wonder what CAN have happened to me! When I used to read fairy-tales, I fancied that kind of thing never happened, and now here I am in the middle of one! There ought to be a book written about me, that there ought! And when I grow up, I'll write one--but I'm grown up now,' she added in a sorrowful tone; 'at least there's no room to grow up any more HERE.'",
      "So she swallowed one of the cakes, and was delighted to find that she began shrinking directly. As soon as she was small enough to get through the door, she ran out of the house, and found quite a crowd of little animals and birds waiting outside. The poor little Lizard, Bill, was in the middle, being held up by two guinea-pigs, who were giving it something out of a bottle. They all made a rush at Alice the moment she appeared; but she ran off as hard as she could, and soon found herself safe in a thick wood.",
      "The door led right into a large kitchen, which was full of smoke from one end to the other: the Duchess was sitting on a three-legged stool in the middle, nursing a baby; the cook was leaning over the fire, stirring a large cauldron which seemed to be full of soup.",
      "But here, to Alice's great surprise, the Duchess's voice died away, even in the middle of her favourite word 'moral,' and the arm that was linked into hers began to tremble. Alice looked up, and there stood the Queen in front of them, with her arms folded, frowning like a thunderstorm."
  ]

  assert { expected == (front.find 'in the middle') }
  assert { []       == (front.find 'in the use') }
  assert { []       == (front.find '') }


  ac = Autocomplete.new
  ac << front

  expected = [["in the same", 3], ["in the other", 3], ["in the last", 3], ["in the wood", 2], ["in the window", 2], ["in the kitchen", 2], ["in the house", 2], ["in the direction", 2]]
  assert { expected == ac['in the'] }

  R.flushall


  m = Manager.new
  fronts.each { |f| m << f }

  expected = ["At last the Mouse, who seemed to be a person of authority among them, called out, 'Sit down, all of you, and listen to me! I'LL soon make you dry enough!' They all sat down at once, in a large ring, with the Mouse in the middle. Alice kept her eyes anxiously fixed on it, for she felt sure she would catch a bad cold if she did not get dry very soon.", "'It was much pleasanter at home,' thought poor Alice, 'when one wasn't always growing larger and smaller, and being ordered about by mice and rabbits. I almost wish I hadn't gone down that rabbit-hole--and yet--and yet--it's rather curious, you know, this sort of life! I do wonder what CAN have happened to me! When I used to read fairy-tales, I fancied that kind of thing never happened, and now here I am in the middle of one! There ought to be a book written about me, that there ought! And when I grow up, I'll write one--but I'm grown up now,' she added in a sorrowful tone; 'at least there's no room to grow up any more HERE.'", "So she swallowed one of the cakes, and was delighted to find that she began shrinking directly. As soon as she was small enough to get through the door, she ran out of the house, and found quite a crowd of little animals and birds waiting outside. The poor little Lizard, Bill, was in the middle, being held up by two guinea-pigs, who were giving it something out of a bottle. They all made a rush at Alice the moment she appeared; but she ran off as hard as she could, and soon found herself safe in a thick wood.", "The door led right into a large kitchen, which was full of smoke from one end to the other: the Duchess was sitting on a three-legged stool in the middle, nursing a baby; the cook was leaning over the fire, stirring a large cauldron which seemed to be full of soup.", "But here, to Alice's great surprise, the Duchess's voice died away, even in the middle of her favourite word 'moral,' and the arm that was linked into hers began to tremble. Alice looked up, and there stood the Queen in front of them, with her arms folded, frowning like a thunderstorm.", "Anyhow, in this case the Briton's content with what he has got at home is well grounded. He certainly possesses a first-class language. As a curious example of the quaint use of it by a scholar and clever man in the middle of the seventeenth century, the following account of Sir Thomas Urquhart's book may be of some interest.", "But consider the article. Here, if anywhere, is a test of the power of a language to move with the times. For some reason or other (the real underlying causes of these changes in language needs are obscure) modern life has need of the article, though the highly civilized Romans did very well without it. So strong is this need that, in the middle ages, when Latin was used as an international language by the learned, a definite article (_hic_ or τó) was foisted into the language. How is it with the modern world? The Slavs have remained in this matter at the point of view of the ancient world. They are articleless. Germany has a cumbrous three-gender, four-case article; France rejoices in a two-gender, one-case article with a distinct form for the plural. The ripe product of tendency, the infant heir of the eloquent ages, to whose birth the law of Aryan evolution groaned and travailed until but now, the most useful, if not the \"mightiest,\" monosyllable \"ever moulded by the lips of man,\" the \"the,\" one and indeclinable, was born in the Anglo-Saxon mouth, and sublimed to its unique simplicity by Anglo-Saxon progress.", "The dangers to which we are exposed from our Women must now be manifest to the meanest capacity in Spaceland. If even the angle of a respectable Triangle in the middle class is not without its dangers; if to run against a Working Man involves a gash; if collision with an Officer of the military class necessitates a serious wound; if a mere touch from the vertex of a Private Soldier brings with it danger of death;—what can it be to run against a Woman, except absolute and immediate destruction? And when a Woman is invisible, or visible only as a dim sub-lustrous point, how difficult must it be, even for the most cautious, always to avoid collision!", "“Once in the middle of each week a Law of Nature compels us to move to and fro with a rhythmic motion of more than usual violence, which continues for the time you would take to count a hundred and one. In the midst of this choral dance, at the fifty-first pulsation, the inhabitants of the Universe pause in full career, and each individual sends forth his richest, fullest, sweetest strain. It is in this decisive moment that all our marriages are made. So exquisite is the adaptation of Bass to Treble, of Tenor to Contralto, that oftentimes the Loved Ones, though twenty thousand leagues away, recognise at once the responsive note of their destined Lover; and, penetrating the paltry obstacles of distance, Love unites the three. The marriage in that instant consummated results in a threefold Male and Female offspring which takes its place in Lineland.”"]
  assert { expected == (m.find 'in the middle') }

ensure
  R.flushall
  %x! kill #{foreman_pid} !
  sleep 0.5

  Dir["#{ROOT}/db*"].each { |file| File.delete file }
  File.delete 'spec/dump.rdb'
end
