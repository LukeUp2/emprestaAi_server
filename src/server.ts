import express from 'express'
import { prisma } from '../prisma/connection/prisma'

const app = express()

app.get('/my-contracts/:id', async (req, res) => {
  const userId = req.params.id

  console.log(userId)

  const contracts = await prisma.contract.findMany({
    where: {
      OR: [
        {
          providerId: userId
        },
        {
          receiverId: userId
        }
      ]
    },
    include: {
      item: {
        select: {
          name: true
        }
      }
    },
  })

  res.json(contracts)

})

app.post('/login', async (req, res) => {

  const { email } = req.body

  const user = await prisma.user.findUnique({
    where: { 
      email: email
    }
  })

  if(!user) {
    return { message: 'User not found', logged: false }
  }

  return { message: 'Sucess', logged: true }
})

app.get('/name-of-user/:id', async (req, res) => {
  const userId = req.params.id

  const user = await prisma.user.findUnique({
    where: {
      id: userId,
    },
    select: {
      name: true,
      phone: true
    }
  })

  if(!user){
    res.sendStatus(404);
    res.send({ message: 'User no found' })
    return
  }

  return user

})


app.listen(3333, () => {
  console.log("Server running on port 3333")
})