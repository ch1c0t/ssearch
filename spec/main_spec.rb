require_relative './helper'
require 'fileutils'

include Ssearch

foreman_pid = fork { exec "foreman start -d spec" }
sleep 1

document = Gutenberg::Book.new_from_txt 'spec/data/pg11.txt'
db_file = 'spec/data/db'
f = Ssearch::Front.new db_file, document

describe Ssearch do
  describe Front do
    describe 'when query exists' do
      it 'returns corresponding units' do
        f.find('in the middle').must_equal [
            "At last the Mouse, who seemed to be a person of authority among them, called out, 'Sit down, all of you, and listen to me! I'LL soon make you dry enough!' They all sat down at once, in a large ring, with the Mouse in the middle. Alice kept her eyes anxiously fixed on it, for she felt sure she would catch a bad cold if she did not get dry very soon.",
            "'It was much pleasanter at home,' thought poor Alice, 'when one wasn't always growing larger and smaller, and being ordered about by mice and rabbits. I almost wish I hadn't gone down that rabbit-hole--and yet--and yet--it's rather curious, you know, this sort of life! I do wonder what CAN have happened to me! When I used to read fairy-tales, I fancied that kind of thing never happened, and now here I am in the middle of one! There ought to be a book written about me, that there ought! And when I grow up, I'll write one--but I'm grown up now,' she added in a sorrowful tone; 'at least there's no room to grow up any more HERE.'",
            "So she swallowed one of the cakes, and was delighted to find that she began shrinking directly. As soon as she was small enough to get through the door, she ran out of the house, and found quite a crowd of little animals and birds waiting outside. The poor little Lizard, Bill, was in the middle, being held up by two guinea-pigs, who were giving it something out of a bottle. They all made a rush at Alice the moment she appeared; but she ran off as hard as she could, and soon found herself safe in a thick wood.",
            "The door led right into a large kitchen, which was full of smoke from one end to the other: the Duchess was sitting on a three-legged stool in the middle, nursing a baby; the cook was leaning over the fire, stirring a large cauldron which seemed to be full of soup.",
            "But here, to Alice's great surprise, the Duchess's voice died away, even in the middle of her favourite word 'moral,' and the arm that was linked into hers began to tremble. Alice looked up, and there stood the Queen in front of them, with her arms folded, frowning like a thunderstorm."
        ]
      end
    end

    describe 'when query does not exist' do
      it 'returns empty array' do
        f.find('in the use').must_equal []
        f.find('').must_equal []
      end
    end
  end

  describe Autocomplete do
    it 'compeletes strings' do
      ac = Autocomplete.new
      ac << f
      ac['in the'].must_equal [["in the same", 3], ["in the other", 3], ["in the last", 3], ["in the wood", 2], ["in the window", 2], ["in the kitchen", 2], ["in the house", 2], ["in the direction", 2]]
    end
  end
end

MiniTest::Unit.after_tests do
  %x! kill #{foreman_pid} !
  sleep 1

  File.delete db_file, 'spec/dump.rdb'
end
