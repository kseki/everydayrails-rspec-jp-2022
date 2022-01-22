require 'rails_helper'

RSpec.describe User, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a first name, last name, email, and pssword' do
    user = described_class.new(
      first_name: 'Aaron',
      last_name: 'Sumner',
      email: 'tester@example.com',
      password: 'dottle-nouveau-pavilion-tight-furze'
    )
    expect(user).to be_valid
  end

  # 名が無ければ無効な状態であること
  it 'is invalid without a first name' do
    user = described_class.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  # 姓が無ければ無効な状態であること
  it 'is invalid without a last name' do
    user = described_class.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # メールアドレスが無ければ無効な状態であること
  it 'is invalid without an email address' do
    user = described_class.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email address' do
    described_class.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'tester@example.com',
      password: 'dottle-nouveau-pavilion-tight-furze'
    )
    user = described_class.new(
      first_name: 'Jane',
      last_name: 'Tester',
      email: 'tester@example.com',
      password: 'dottle-nouveau-pavilion-tight-furze'
    )
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string"
end
