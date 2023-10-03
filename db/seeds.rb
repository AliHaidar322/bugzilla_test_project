user1 = User.create!(
  email: 'user1@example.com',
  password: 'password123',
  name: 'User 1',
  user_type: 'manager'
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password123',
  name: 'User 2',
  user_type: 'developer'
)

user3 = User.create!(
  email: 'user3@example.com',
  password: 'password123',
  name: 'User 3',
  user_type: 'qa'
)

project1 = Project.create!(
  name: 'Project 1',
  description: 'Description for Project 1'
)

project2 = Project.create!(
  name: 'Project 2',
  description: 'Description for Project 2'
)

UserProject.create!(
  user: user1,
  project: project1
)

UserProject.create!(
  user: user1,
  project: project2
)

UserProject.create!(
  user: user2,
  project: project1
)

UserProject.create!(
  user: user3,
  project: project1
)

Bug.create!(
  title: 'Bug 1',
  description: 'Description for Bug 1',
  bug_type: 'feature',
  status: 1,
  deadline: Date.today + 7.days,
  user: user1,
  project: project1
)

Bug.create!(
  title: 'Bug 2',
  description: 'Description for Bug 2',
  bug_type: 'bug',
  status: 2,
  deadline: Date.today + 14.days,
  user: user2,
  project: project2
)
