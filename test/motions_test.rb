require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = Vimmish.parser

describe 'motions' do
  describe 'arrows' do
    include Assertions
    {
      'one character to the left' => ['h', '<LEFT>'],
      'down' => ['j', '<DOWN>'],
      'up' => ['k', '<UP>'],
      'one character to the right' => ['l', '<RIGHT>'],
    }.each_pair do |move, commands|
      commands.each do |vim|
        it "should parse #{vim} and translate correctly" do
          vim.should parse_to(parser, [[vim, "move #{move}"]])
        end
      end
    end
  end

  describe 'character movement' do
    include Assertions
    {
      'fy' => 'move on the next y',
      'Fy' => 'move on the previous y',
      'ty' => 'move before the next y',
      'Ty' => 'move before the previous y',
      ';' => 'repeat last character find',
    }.each_pair do |vim, result|
      it "should parse #{vim} and translate correctly" do
        vim.should parse_to(parser, [[vim, result]])
      end
      
      it "should parse 2#{vim} and translate correctly" do
        vim = "2#{vim}"
        vim.should parse_to(parser, [[vim, "#{result}, 2 times"]])
      end
    end
  end

  describe 'word movement' do
    include Assertions
    {
      'w' => 'move to the begining of the next word',
      '4w' => 'move to the begining of the next word, 4 times',
      'W' => 'move to the begining of the next space-separated word',
      '4W' => 'move to the begining of the next space-separated word, 4 times',
      'b' => 'move to the begining of the previous word',
      '7b' => 'move to the begining of the previous word, 7 times',
      'e' => 'move to the end of the next word',
      '3e' => 'move to the end of the next word, 3 times',
      'ge' => 'move to the end of the previous word',
      '3ge' => 'move to the end of the previous word, 3 times',
      'B' => 'move backwards one space-separated-word',
      '7B' => 'move backwards one space-separated-word, 7 times',
      'E' => 'move to the end of the next space-separated-word',
      '3E' => 'move to the end of the next space-separated-word, 3 times',
      'gE' => 'move to the end of the previous space-separated-word',
      '3gE' => 'move to the end of the previous space-separated-word, 3 times',
    }.each_pair do |vim, result|
      it "should parse #{vim} and translate correctly" do
        vim.should parse_to(parser, [[vim, result]])
      end
    end
  end

  describe 'line movement' do
    include Assertions
    {
      '^'  => 'move to the begining of the line (not blank character)',
      '3^' => 'move to the begining of the line (not blank character)', # no effect
      '0' => 'move to the begining of the line', # cannot take count
      '$'  => 'move to the end of the line',
      '1$' => 'move to the end of the line',
      '3$' => 'move to the end of the line that is 2 lines below',
    }.each_pair do |vim, result|
      it "should parse #{vim} and translate correctly" do
        vim.should parse_to(parser, [[vim, result]])
      end
    end
  end

  describe 'syntax-dependent movement' do
    include Assertions
    {
      '%' => 'move to the matching paranthesys',
    }.each_pair do |vim, result|
      it "should parse #{vim} and translate correctly" do
        vim.should parse_to(parser, [[vim, result]])
      end
    end
  end

  
  describe 'moving to specific lines' do
    include Assertions
    {
      'G' => 'move to last line (end of file)',
      '3G' => 'move to line 3',
      'gg' => 'move to first line (beginning of file)',
      '15gg' => 'move to line 15',
      #TODO %90 = 90%
      #TODO H - home, M - middle, L - last
      #CTRL+U scroll down 50%, CTRL+D scroll up 50%,
      #CTRL+E scroll up 1 line, CTRL+Y scroll down 1 line,
      #CTRL+F scroll forward screen, CTRL+B scroll backword screen
    }.each_pair do |vim, result|
      it "should parse #{vim} and translate correctly" do
        vim.should parse_to(parser, [[vim, result]])
      end
    end
  end
end
