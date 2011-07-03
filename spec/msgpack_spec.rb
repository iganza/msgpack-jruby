# encoding: ascii-8bit

require_relative 'spec_helper'


describe MessagePack do
  describe '#pack' do
    tests = {
      'constant values' => [
        ['true', true, "\xC3"],
        ['false', false, "\xC2"],
        ['nil', nil, "\xC0"]
      ],
      'numbers' => [
        ['small integers', 42, "*"],
        ['medium integers', 333, "\xCD\x01M"],
        ['large integers', 2**31 - 1, "\xCE\x7F\xFF\xFF\xFF"],
        ['huge integers', 2**64 - 1, "\xCF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"],
        ['negative integers', -1, "\xFF"],
        ['small floats', 3.14, "\xCB@\t\x1E\xB8Q\xEB\x85\x1F"],
        ['big floats', Math::PI * 1_000_000_000_000_000_000, "\xCBC\xC5\xCC\x96\xEF\xD1\x19%"],
        ['negative floats', -2.1, "\xCB\xC0\x00\xCC\xCC\xCC\xCC\xCC\xCD"]
      ],
      'strings' => [
        ['strings', 'hello world', "\xABhello world"],
        ['empty strings', '', "\xA0"]
      ],
      'symbols' => [
        ['symbols as strings', :symbol, "\xA6symbol"]
      ],
      'arrays' => [
        ['arrays with strings', ["hello", "world"], "\x92\xA5hello\xA5world"],
        ['arrays with mixed values', ["hello", "world", 42], "\x93\xA5hello\xA5world*"],
        ['arrays of arrays', [[[[1, 2], 3], 4]], "\x91\x92\x92\x92\x01\x02\x03\x04"],
        ['empty arrays', [], "\x90"]
      ],
      'hashes' => [
        ['hashes', {'foo' => 'bar'}, "\x81\xA3foo\xA3bar"],
        ['hashes with mixed keys and values', {'foo' => 'bar', 3 => 'three', 'four' => 4, 'x' => ['y'], :a => :b}, "\x85\xA3foo\xA3bar\x03\xA5three\xA4four\x04\xA1x\x91\xA1y\xA1a\xA1b"],
        ['hashes of hashes', {{'x' => {'y' => 'z'}} => 's'}, "\x81\x81\xA1x\x81\xA1y\xA1z\xA1s"]
      ]
    }

    tests.each do |ctx, its|
      context("with #{ctx}") do
        its.each do |desc, unpacked, packed|
          it("encodes #{desc}") do
            MessagePack.pack(unpacked).should == packed
          end
          
          it "decodes #{desc}"
        end
      end
    end
    
    context 'with other things' do
      it 'raises an error' do
        expect { MessagePack.pack(self) }.to raise_error(ArgumentError, /^Cannot pack type:/)
      end
    end
  end
end