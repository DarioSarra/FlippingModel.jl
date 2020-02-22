using GLM
model = lm(@formula(r ~ Protocol + Wall),comp)
nullmodel = lm(@formula(r ~ Protocol ),comp)
ftest(nullmodel.model, model.model)

model = lm(@formula(r ~ Protocol + Wall),comp)
nullmodel = lm(@formula(r ~ Wall ),comp)
ftest(nullmodel.model, model.model)

model = lm(@formula(T ~ Protocol + Wall),comp)
nullmodel = lm(@formula(T ~ Protocol ),comp)
ftest(nullmodel.model, model.model)

model = lm(@formula(T ~ Protocol + Wall),comp)
nullmodel = lm(@formula(T ~ Wall ),comp)
ftest(nullmodel.model, model.model)

###

model = lm(@formula(lapse ~ Protocol + Wall),comp)
nullmodel = lm(@formula(lapse ~ Protocol ),comp)
ftest(nullmodel.model, model.model)

model = lm(@formula(lapse ~ Protocol + Wall),comp)
nullmodel = lm(@formula(lapse ~ Wall ),comp)
ftest(nullmodel.model, model.model)
