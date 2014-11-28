# -*- coding: utf-8 -*-
require 'spec_helper'

describe RqrcodePngBin::FileReader do
  describe '#split!' do
    let(:reader) {
      RqrcodePngBin::FileReader.new(File.dirname(__FILE__) + '/support/dummy')
    }
    let(:str) {
      reader.instance_variable_get('@str')
    }
    let(:dest) {
      reader.instance_variable_get('@dest')
    }

    context 'empty' do
      before {
        reader.split!('')
      }
      context '@str' do
        it { expect(str).to be_nil }
      end
      context '@dest' do
        it { expect(dest).to be_nil }
      end
    end
    context 'only string without escape' do
      before {
        reader.split!('abc')
      }
      context '@str' do
        it { expect(str).to be == 'abc' }
      end
      context '@dest' do
        it { expect(dest).to be == 'abc.png' }
      end
    end
    context 'only string with escape' do
      before {
        reader.split!('http://github.com')
      }
      context '@str' do
        it { expect(str).to be == 'http://github.com' }
      end
      context '@dest' do
        it { expect(dest).to be == 'http:%2F%2Fgithub.com.png' }
      end
    end
    context 'string with filename' do
      before {
        reader.split!("str\tfilename")
      }
      context '@str' do
        it { expect(str).to be == 'str' }
      end
      context '@dest' do
        it { expect(dest).to be == 'filename' }
      end
    end
    context 'japanese string' do
      before {
        reader.split!("日本/語")
      }
      context '@str' do
        it { expect(str).to be == '日本/語' }
      end
      context '@dest' do
        it { expect(dest).to be == '日本%2F語.png' }
      end
    end
  end
end
