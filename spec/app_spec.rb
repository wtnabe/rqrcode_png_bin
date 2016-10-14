# -*- coding: utf-8 -*-
require 'spec_helper'

describe RqrcodePngBin::App do
  def app(argv = [])
    RqrcodePngBin::App.new(argv)
  end

  describe '#parser' do
    context 'border modules' do
      context 'nil' do
        it {
          expect(app.border_modules).to be(4)
        }
      end
      context '4' do
        it {
          expect(app(%w(-b 4)).border_modules).to be(4)
        }
      end
      context 'a' do
        it {
          expect {app(%w(-b a)).border_modules}.to raise_error(ArgumentError)
        }
      end
    end
    context 'canvas' do
      context 'nil' do
        it {
          expect(app.canvas).to be_nil
        }
      end
      context '200x200' do
        it {
          expect(app(%w(-c 200)).canvas).to be(200)
        }
      end
      context 'abc' do
        it {
          expect {app(%w(-c abc))}.to raise_error(ArgumentError)
        }
      end
    end
    context 'file' do
      context 'nil' do
        it {
          expect(app.file).to be_nil
        }
      end
      context 'file exist' do
        it {
          expect(app(['-f', __FILE__]).file).to be == __FILE__
        }
      end
      context 'file not exist' do
        it {
          expect {app(%w(-f foo)).file}.to raise_error(ArgumentError)
        }
      end
    end
    context 'level' do
      context 'nil' do
        it {
          expect(app.level).to be == :m
        }
      end
      context 'h' do
        it {
          expect(app(%w(-l h)).level).to be == :h
        }
      end
      context 'z' do
        it {
          expect {app(%w(-l z))}.to raise_error(ArgumentError)
        }
      end
    end
    context 'mode' do
      context 'nil' do
        it {
          expect(app.mode).to be_nil
        }
      end
      context 'number' do
        it {
          expect(app(%w(-m number)).mode).to be(:number)
        }
      end
      context 'foo' do
        it {
          expect {app(%w(-m foo))}.to raise_error(ArgumentError)
        }
      end
    end
    context 'px_per_module' do
      context 'nil' do
        it {
          expect(app.px_per_module).to be_nil
        }
      end
      context '10' do
        it {
          expect(app(%w(-p 10)).px_per_module).to be(10)
        }
      end
      context 'a' do
        it {
          expect {app(%w(-p a))}.to raise_error(ArgumentError)
        }
      end
    end
    context 'size' do
      context 'nil' do
        it {
          expect(app.size).to be == 4
        }
      end
      context '5' do
        it {
          expect(app(%w(-s 5)).size).to be == 5
        }
      end
      context 'a' do
        it {
          expect {app(%w(-s a))}.to raise_error(ArgumentError)
        }
      end
    end
  end
end
