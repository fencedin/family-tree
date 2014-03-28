require 'spec_helper'

describe Parent do
  it { should belong_to :mom }
  it { should belong_to :dad }
  it { should belong_to :person }
end
