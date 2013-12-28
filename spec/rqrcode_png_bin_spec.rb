# -*- coding: utf-8 -*-
require 'spec_helper'

describe RqrcodePngBin do
  def app(argv = [])
    RqrcodePngBin::App.new(argv)
  end

  describe '#parser' do
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
    context 'canvas' do
      context 'nil' do
        it {
          expect(app.canvas).to be_nil
        }
      end
      context '200x200' do
        it {
          expect(app(%w(-c 200x200)).canvas).to be == [200, 200]
        }
      end
      context 'abc' do
        it {
          expect {app(%w(-c abc))}.to raise_error(ArgumentError)
        }
      end
    end
  end
end
