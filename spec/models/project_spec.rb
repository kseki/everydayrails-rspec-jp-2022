require 'rails_helper'

RSpec.describe Project, type: :model do
  # 締切日が過ぎていれば遅延していること
  it 'is late when the due date is past today' do
    project = FactoryBot.create(:project, :due_yesterday)
    expect(project).to be_late
  end

  # 締切日が今日ならスケジュールどおりであること
  it 'is no time when the due date is today' do
    project = FactoryBot.create(:project, :due_today)
    expect(project).not_to be_late
  end

  # 締切日が未来ならスケジュールどおりであること
  it 'is no time when the due date is feature' do
    project = FactoryBot.create(:project, :due_tomorrow)
    expect(project).not_to be_late
  end

  # ユーザー単位では重複したプロジェクトを許可しないこと
  it 'dose not allow duplicate project names per user' do
    user = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'tester@example.com',
      password: 'dottle-nouveau-pavilion-tight-furze'
    )

    user.projects.create(
      name: 'Test Project'
    )

    new_project = user.projects.build(
      name: 'Test Project'
    )
    new_project.valid?

    expect(new_project.errors[:name]).to include('has already been taken')
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it 'allows two users to share a project name' do
    user = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'joetester@example.com',
      password: 'dottle-nouveau-pavilion-tight-furze'
    )

    user.projects.create(
      name: 'Test Project'
    )

    other_user = User.create(
      first_name: 'Jane',
      last_name: 'Tester',
      email: 'janetester@example.com',
      password: 'dottle-nouveau-pavilion-tight-furze'
    )

    other_project = other_user.projects.create(
      name: 'Test Project'
    )

    expect(other_project).to be_valid
  end
end
