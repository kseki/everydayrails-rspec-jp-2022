require 'rails_helper'

RSpec.describe Note, type: :model do
  # 検索文字列に一致するメモを返すこと
  it 'returns notes that match the search term' do
    user = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'tester@example.com',
      password: 'dottle-nouveau-pavilion-tight-furze'
    )

    project = user.projects.create(
      name: 'Test Project'
    )

    note1 = project.notes.create(
      message: 'This is the first note.',
      user:
    )
    note2 = project.notes.create(
      message: 'This is the second note.',
      user:
    )
    note3 = project.notes.create(
      message: 'First, preheat the oven.',
      user:
    )

    expect(described_class.search('first')).to include(note1, note3)
    expect(described_class.search('first')).not_to include(note2)
  end
end
